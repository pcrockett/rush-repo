#!/usr/bin/env bash
set -euo pipefail

# Execute scripts in occasional.d directories
#
# Usage: occasional.d [minute|hour|day|week|month]
#
# Example usage:
#
#     # execute scripts in ~/.config/occasional.d/hour
#     occasional.d hour
#
#     # execute global scripts in /etc/occasional.d/day
#     sudo occasional.d day
#

CLI_ARGS=("$@")

panic() {
  echo "FATAL: $*" >&2
  exit 1
}

init() {
  test "${#CLI_ARGS[@]}" -eq 1 || panic "expecting exactly one argument: minute, hour, day, week, or month"

  if [ "$(id --user)" -eq 0 ]; then
    cd / || panic "unable to cd to /"
    XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"/etc"}"
  else
    cd "${HOME}" || panic "unable to cd to \$HOME (${HOME})"
    XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
  fi

  OCCASIONAL_CONFIG_DIR="${XDG_CONFIG_HOME}/occasional.d"

  TIME_INTERVAL="${CLI_ARGS[0]:-}"
  case "${TIME_INTERVAL}" in
    minute|hour|day|week|month)
      true  # input looks good, carry on
      ;;
    "")
      panic "must specify one of minute, hour, day, week, or month as first argument"
      ;;
    *)
      panic "unrecognized argument: ${TIME_INTERVAL}"
      ;;
  esac
}

main() {
  init
  exit_code=0
  script_dir="${OCCASIONAL_CONFIG_DIR}/${TIME_INTERVAL}"

  (
    umask u=rwx,g=,o=  # restrict permissions so it's safe to hard-code secrets in scripts
    mkdir --parent "${script_dir}"
  )
  test -d "${script_dir}" || panic "not a directory: ${script_dir}"
  while read -r script; do
    echo "starting: ${script}"
    if "${script}"; then
      echo "exited with code $?: ${script}"
    else
      echo "ERROR: exited with code $?: ${script}"
      exit_code=1
    fi
  done < <(find "${script_dir}" -maxdepth 1 -executable -type f)

  echo "finished executing scripts."
  exit ${exit_code}
}

main
