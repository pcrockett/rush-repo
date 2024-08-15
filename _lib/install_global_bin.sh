# shellcheck shell=bash

install_global_bin() {
    require_commands sudo

    local source_bin_file="${1}"
    test -d "${RUSH_GLOBAL_BIN}" || panic "Not a directory: ${RUSH_GLOBAL_BIN}"

    command=(install "${source_bin_file}" "${RUSH_GLOBAL_BIN}")
    if [ "$(id --user)" -eq 0 ]; then
        "${command[@]}"
    else
        sudo "${command[@]}"
    fi
}
