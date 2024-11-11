# shellcheck shell=bash

curl_download() {
    local url="${1}"
    require_commands curl
    curl --proto '=https' --tlsv1.2 \
        --silent \
        --show-error \
        --fail \
        --location "${url}"
}
