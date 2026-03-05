#!/usr/bin/env bash
set -euo pipefail

# Add or remove Markdown **bold**
#
# Usage: hx-bold.sh
#
# Example usage:
#
#     # add bold stars
#     echo "foobar" | hx-bold.sh
#
#     # remove bold stars
#     echo "**foobar**" | hx-bold.sh
#
#     # in helix config.toml, map Ctrl+B to bold / unbold current selection
#     [keys.normal]
#     C-b = ":pipe hx-bold.sh"
#

main() {
  contents="$(cat)"
  if [[ "${contents}" =~ ^\*\*(.*)\*\*$ ]]; then
    echo -n "${BASH_REMATCH[1]}"
  else
    echo -n "**${contents}**"
  fi
}

main
