# shellcheck shell=bash
# [tag:curl_download]

curl_download() {
  local url="${1}"
  require_commands curl

  curl_cmd=(
    curl
    --proto '=https'
    --tlsv1.2
    --silent
    --show-error
    --fail
  )

  if [[ "${url}" =~ ^https://api\.github\.com/ ]]; then
    if [ "${GITHUB_TOKEN:-}" != "" ]; then
      curl_cmd+=(--header "Authorization: Bearer ${GITHUB_TOKEN}")
    elif command -v gh &>/dev/null; then
      curl_cmd+=(--header "Authorization: Bearer $(gh auth token)")
    fi
  fi

  "${curl_cmd[@]}" --location "${url}"
}
