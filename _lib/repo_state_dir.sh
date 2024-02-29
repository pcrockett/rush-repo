# shellcheck shell=bash

repo_state_dir() {
    local state_home="${XDG_STATE_HOME:-${HOME}/.local/state}"
    local state_dir="${state_home}/rush/pcrockett"
    mkdir --parent "${state_dir}"
    echo "${state_dir}"
}
