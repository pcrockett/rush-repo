# shellcheck shell=bash

command_exists() {
  for command in "${@}"; do
    command -v "${command}" &>/dev/null || return 1
  done
}
