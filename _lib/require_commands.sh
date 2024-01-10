# shellcheck shell=bash

require_commands() {
    local missing_commands=()
    for command in "${@}"; do
        if ! command -v "${command}" &> /dev/null; then
            missing_commands+=("${command}")
        fi
    done

    if [ "${#missing_commands[@]}" -gt 0 ]; then
        panic "Required command(s) not found: ${missing_commands[*]}"
    fi
}
