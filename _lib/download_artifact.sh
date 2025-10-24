# shellcheck shell=bash

download_artifact() {
  local url="${1:?Expected URL as first parameter}"
  local dest="${2:?Expected destination path as second parameter}"
  if command -v yolodl &>/dev/null; then
    yolodl "${url}" "${dest}" --quiet
  else
    curl_download "${url}" >"${dest}"
  fi
}
