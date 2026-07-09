#!/usr/bin/env nu
# [tag:github_latest_tag_nu]

# get the latest github release for a project, with cooldown in $RUSH_COOLDOWN
def main [
  owner: string
  repo: string
] {
  let endpoint = $"https://api.github.com/repos/($owner)/($repo)/releases/latest"
  let auth_token = (
    $env.GITHUB_TOKEN?
    | default {
      let gh_command = which gh | first | get --optional path
      if ($gh_command | is-not-empty) {
        ^$gh_command auth token
      } else {
        null
      }
    }
  )
  let headers = (
    if ($auth_token | is-not-empty) {
      [Authorization $"Bearer ($auth_token)"]
    } else {
      []
    }
  )
  let release = http get $endpoint --headers $headers
  let release_date = (
    if ($release.updated_at? | is-empty) {
      null
    } else {
      $release.updated_at | into datetime
    }
  )

  let cooldown = $env.RUSH_COOLDOWN? | default "1wk" | into duration
  if ((date now) - $release_date > $cooldown) {
    $release.tag_name | print
  }

  ignore
}
