#!/usr/bin/env bash
set -Eeuo pipefail

# TODO: Synopsis here
#
# Usage: [TODO]
#
# Example usage:
#
#     [TODO]
#
# Dependencies:
#
# * [TODO]
#

CLI_ARGS=("$@")

panic() {
    echo "$*" >&2
    exit 1
}

init() {
    panic "not implemented yet"
}

main() {
    init
    panic "not implemented yet"
}

main
