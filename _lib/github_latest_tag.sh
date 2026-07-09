# shellcheck shell=bash
# [tag:github_latest_tag]

github_latest_tag() {
  local owner="${1}"
  local repo="${2}"
  if command -v nu &>/dev/null; then
    # [ref:github_latest_tag_nu]
    "${REPO_PATH}/_lib/github_latest_tag.nu" "${owner}" "${repo}"
  else
    curl_download "https://api.github.com/repos/${owner}/${repo}/releases/latest" \
      | grep --perl-regexp --only-matching '(?<="tag_name":)\s*"\S+"' \
      | tr --delete '" '
  fi
}
