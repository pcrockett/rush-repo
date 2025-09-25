#!/usr/bin/env bash
set -euo pipefail

REPO="${1?Must specify repository, ex: pcrockett/rush-repo}"
gh repo view "${REPO}" --json description --template '{{.description}}' \
  | awk '{$1=$1;print}' \
    >info
