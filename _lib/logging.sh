# shellcheck shell=bash

# much of this borrowed / modified from https://github.com/DannyBen/rush-repo/blob/master/_lib/output.sh

log_info() {
  printf "%-20s | %s\n" "$(cyan "${RUSH_PACKAGE_NAME}")" "${*}"
}

log_attention() {
  printf "%-20s | %s\n" "$(cyan "${RUSH_PACKAGE_NAME}")" "$(green "${*}")"
}

log_warning() {
  printf "%-20s | %s\n" "$(cyan "${RUSH_PACKAGE_NAME}")" "$(yellow "WARNING: ${*}")"
}

log_error() {
  printf "%-20s | %s\n" "$(cyan "${RUSH_PACKAGE_NAME}")" "$(red "ERROR: ${*}")"
}
