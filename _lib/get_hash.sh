# shellcheck shell=bash

get_hash() {
  # example usage: `get_hash < some/file/path`
  sha256sum - | cut --fields 1 --delimiter " " --only-delimited
}

get_file_hash() {
  # example usage: `get_file_hash some/file/path`
  local path="${1}"
  test -f "${path}" || return 0 # Return nothing
  get_hash <"${path}"
}

files_are_same() {
  test "$(get_file_hash "${1}")" == "$(get_file_hash "${2}")"
}
