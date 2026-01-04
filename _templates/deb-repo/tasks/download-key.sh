#!/usr/bin/env bash
set -euo pipefail

KEY_URL="${1:?Must specify key URL}"
KEY_FILENAME="${2:?Must specify key filename}"
NEEDS_DEARMOR="${3:?Must specify whether the key needs to be dearmored before saving}"

curl_download() {
  # copy / paste / modified from [ref:curl_download]
  local url="${1}"

  curl_cmd=(
    curl
    --proto '=https'
    --tlsv1.3
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

main() {
  curl_download "${KEY_URL}" >"${KEY_FILENAME}.tmp"
  if [ "${NEEDS_DEARMOR}" == "True" ]; then
    gpg --dearmor --output "${KEY_FILENAME}" <"${KEY_FILENAME}.tmp"
    rm "${KEY_FILENAME}.tmp"
  else
    mv "${KEY_FILENAME}.tmp" "${KEY_FILENAME}"
  fi
}

main
