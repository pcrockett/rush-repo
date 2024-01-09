# shellcheck shell=bash
set -Eeuo pipefail

for file in "${REPO_PATH}"/_lib/*.sh; do
    # shellcheck source=/dev/null
    source "${file}"
done

mkdir --parent "${RUSH_USER_BIN}"
test -d "${RUSH_GLOBAL_BIN}" || mkdir --parent "${RUSH_GLOBAL_BIN}"
