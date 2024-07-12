# shellcheck shell=bash

repo_state_dir() {
    local state_dir="${XDG_STATE_HOME}/rush/pcrockett"
    mkdir --parent "${state_dir}"
    echo "${state_dir}"
}
