# shellcheck shell=bash

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

    if [ "${GITHUB_TOKEN:-}" != "" ] && [[ "${url}" =~ ^https://api\.github\.com/ ]]; then
        curl_cmd+=(--header "Authorization: Bearer ${GITHUB_TOKEN}")
    fi

    "${curl_cmd[@]}" --location "${url}"
}
