#!/usr/bin/env nu

const IMAGE_CONTAINER_CUTOFF = 30day
let IMAGE_CONTAINER_CUTOFF_HOURS = ($IMAGE_CONTAINER_CUTOFF | into hours)
let NOW = (date now)

def main [] {
  let before_usage = ^docker system df
  purge-dead-containers
  purge-unused-containers

  print "Pruning networks..."
  ^docker network prune --force

  print "Pruning volumes..."
  ^docker volume prune --force --filter "label!=keep"

  print "Pruning images..."
  ^docker image prune --force --all --filter $"until=($IMAGE_CONTAINER_CUTOFF_HOURS)h"

  print "Pruning buildx build cache..."
  ^docker buildx prune --force --all --reserved-space 5G

  print "============== BEFORE CLEANUP ==============="
  print $before_usage
  print "============================================="
  print "============== AFTER CLEANUP ================"
  ^docker system df
  print "============================================="

}

# find containers which have haven't run for a long time, and give them "the treatment"
def purge-dead-containers [] {
  # this is preferred over the `docker container prune` command because the "until"
  # filter there works on container _creation_ date. this function is designed to look
  # at when a container was last used, not when it was created.

  let unused_ids = (
    ^docker ps --filter status=exited --filter status=dead --format "{{.ID}}"
    | lines
  )

  if ($unused_ids | length) == 0 {
    print "No dead / exited containers found."
    return
  }

  let to_purge = (
    ^docker inspect ...$unused_ids
    | from json
    | each {
      {
        id: $in.Id
        last_exited: ($in.State.FinishedAt | into datetime)
      }
    }
    | where { ($NOW - $in.last_exited) > $IMAGE_CONTAINER_CUTOFF }
    | each { $in.id }
  )

  let purge_count = ($to_purge | length)
  if ($purge_count) > 0 {
    ^docker container rm --volumes ...$to_purge
  }
  print $"Purged ($purge_count) dead / exited containers."
}

# find containers which have been created but remain unused, and give them "the treatment"
def purge-unused-containers [] {
  # this is preferred over the `docker container prune` command because the filters
  # available there don't allow status=created

  let unused_ids = (
    ^docker ps --filter status=created --format "{{.ID}}"
    | lines
  )

  if ($unused_ids | length) == 0 {
    print "No unused containers found."
    return
  }

  let to_purge = (
    ^docker inspect ...$unused_ids
    | from json
    | each {
      {
        id: $in.Id
        age: ($NOW - ($in.Created | into datetime))
      }
    }
    | where { $in.age > $IMAGE_CONTAINER_CUTOFF }
    | each { $in.id }
  )

  let purge_count = ($to_purge | length)
  if ($purge_count) > 0 {
    ^docker container rm --volumes ...$to_purge
  }
  print $"Purged ($purge_count) unused containers."
}

def "into hours" []: duration -> float {
  ($in | into int) / 1_000_000_000 / 60 / 60
}
