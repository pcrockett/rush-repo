# shellcheck shell=bash

github_latest_tag() {
  local owner="${1}"
  local repo="${2}"
  curl_download "https://api.github.com/repos/${owner}/${repo}/releases/latest" \
    | grep --perl-regexp --only-matching '(?<="tag_name":)\s*"\S+"' \
    | tr --delete '" '
}
