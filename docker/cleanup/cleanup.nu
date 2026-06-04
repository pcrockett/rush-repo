#!/usr/bin/env nu

const OLD_CUTOFF = 30day
let OLD_CUTOFF_SECONDS = ($OLD_CUTOFF | into int) / 1_000_000_000 | into int

def main [] {
  purge-dead-containers
  purge-unused-containers
  ^docker system prune -f --filter $"until=($OLD_CUTOFF_SECONDS)" | ignore
}

# find containers which have haven't run for a long time, and give them "the treatment"
def purge-dead-containers [] {
  let dead_containers = (
    ^docker ps --filter status=exited --filter status=dead --format json
    | from json --objects
    | each {
      {
        id: $in.ID
        last_exited: (
          $in.Status
          | parse "Exited ({code}) {age} {units} ago"
          | each { docker-age-to-duration }
        ).0
      }
    }
    | where { $in.last_exited > $OLD_CUTOFF }
  )
  let purged_count = (
    $dead_containers
    | each { ^docker container rm $in.id }
    | length
  )
  print $"Purged ($purged_count) dead / exited containers."
}

# find containers which have been created but remain unused, and give them "the treatment"
def purge-unused-containers [] {
  let unused = (
    ^docker ps --filter status=created --format json
    | from json --objects
    | each {
      {
        id: $in.ID
        age: (
          # don't be fooled by the naming of `RunningFor` -- these containers have never
          # been run.
          $in.RunningFor
          | parse "{age} {units} ago"
          | each { docker-age-to-duration }
        ).0
      }
    }
    | where { $in.age > $OLD_CUTOFF }
  )
  let purged_count = (
    $unused
    | each { ^docker container rm $in.id }
    | length
  )
  print $"Purged ($purged_count) unused containers."
}

def docker-age-to-duration []: record<age: string, units: string> -> duration {
  let status = $in
  let age = $status.age | into int
  match $status.units {
    "years" => { ($age * 365)day }
    "months" => { ($age * 30)day }
    "weeks" => { ($age)wk }
    "days" => { ($age)day }
    "hours" => { ($age)hr }
    "minutes" => { ($age)min }
    "seconds" => { ($age)sec }
    $x => { error make { msg: $"Unrecognized timespan: ($age) ($x)" } }
  } | into duration
}
