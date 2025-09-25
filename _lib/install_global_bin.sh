# shellcheck shell=bash

install_global_bin() {
  local source_bin_file="${1}"
  test -d "${RUSH_GLOBAL_BIN}" || panic "Not a directory: ${RUSH_GLOBAL_BIN}"
  as_root install "${source_bin_file}" "${RUSH_GLOBAL_BIN}"
}
