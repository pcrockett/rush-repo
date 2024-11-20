#!/usr/bin/env bash
# shellcheck disable=SC2317  # shellcheck thinks some functions are unused b/c we're dynamically calling them in `main`
set -Eeuo pipefail

# TODO: Synopsis here
#
# See `usage` function below for details.
#
# Dependencies:
#
# * TODO
#

usage() {
    local command_name
    command_name="$(basename "${0}")"
    cat <<EOF
${command_name}: TODO: Synopsis here

Usage: ${command_name} [OPTIONS...] [SUBCOMMAND]

Subcommands:

    help        Display this message

Options:

    --TODO:     TODO: description of option

Examples:

    # TODO: explanation of command below
    ${command_name} --TODO

EOF
}

panic() {
    echo "$*" >&2
    exit 1
}

init() {
    SUBCOMMAND="help"
    SUBCOMMAND_ARGS=()
}

subcommand:help() {
    usage
}

parse_args() {
    while [ ${#} -ge 1 ]; do
        case "${1}" in
            help|-h|--help|/?)
                SUBCOMMAND="help"
            ;;
            --TODO)
                SUBCOMMAND_ARGS+=("TODO")
            ;;
            *)
                panic "Unrecognized arg: \"${1}\". See --help for usage."
            ;;
        esac
        shift
    done
}

main() {
    init
    parse_args "${@}"
    "subcommand:${SUBCOMMAND}" "${SUBCOMMAND_ARGS[@]}"
    exit $?  # in case this script changes while running
}

main "${@}"
