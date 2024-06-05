# shellcheck shell=bash

require_packages() {
    local missing_packages=()
    for package in "${@}"; do
        if ! dpkg --status "${package}" &> /dev/null; then
            missing_packages+=("${package}")
        fi
    done

    if [ "${#missing_packages[@]}" -gt 0 ]; then
        panic "Required package(s) not found: ${missing_packages[*]}"
    fi
}
