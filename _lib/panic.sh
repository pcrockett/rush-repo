# shellcheck shell=bash

panic() {
  log_error "${*}" >&2
  exit 1
}
