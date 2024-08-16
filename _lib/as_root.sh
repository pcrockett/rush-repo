# shellcheck shell=bash

as_root() {
    if [ "$(id --user)" -eq 0 ]; then
        "${@}"
    else
        require_commands sudo
        log_info "Running \`sudo -- ${*}\`..."
        sudo -- "${@}"
    fi
}
