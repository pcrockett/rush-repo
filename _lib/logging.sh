# shellcheck shell=bash

# much of this borrowed / modified from https://github.com/DannyBen/rush-repo/blob/master/_lib/output.sh

log_info() {
    printf "%-20s | %s\n" "$(cyan "$(basename "${PWD}")")" "${*}"
}

log_attention() {
    printf "%-20s | %s\n" "$(cyan "$(basename "${PWD}")")" "$(green "${*}")"
}

log_warning() {
    printf "%-20s | %s\n" "$(cyan "$(basename "$PWD")")" "$(yellow "WARNING: ${*}")"
}

log_error() {
    printf "%-20s | %s\n" "$(cyan "$(basename "${PWD}")")" "$(red "ERROR: ${*}")"
}
