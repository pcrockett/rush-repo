# shellcheck shell=bash

install_user_bin() {
  local source_bin_file="${1}"
  mkdir --parent "${RUSH_USER_BIN}"
  install "${source_bin_file}" "${RUSH_USER_BIN}"
}
