# shellcheck shell=bash

RUSH_USER_BIN="${RUSH_USER_BIN:-"${HOME}/.local/bin"}"
RUSH_GLOBAL_BIN="${RUSH_GLOBAL_BIN:-"/usr/local/bin"}"

RUSH_PACKAGE_NAME="$(basename "${PWD}")"
export RUSH_PACKAGE_NAME
