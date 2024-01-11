# shellcheck shell=bash
set -Eeuo pipefail

for file in "${REPO_PATH}"/_lib/*.sh; do
    # shellcheck source=/dev/null
    source "${file}"
done
