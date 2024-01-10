# shellcheck shell=bash

panic() {
    echo "FATAL: ${*}" >&2
    exit 1
}
