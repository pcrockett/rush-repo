# shellcheck shell=bash

XDG_STATE_HOME="${XDG_STATE_HOME:-"${HOME}/.local/state"}"
XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}/.local/share"}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-"${HOME}/.cache"}"

RUSH_USER_BIN="${RUSH_USER_BIN:-"${HOME}/.local/bin"}"
RUSH_GLOBAL_BIN="${RUSH_GLOBAL_BIN:-"/usr/local/bin"}"

RUSH_PACKAGE_NAME="$(basename "${PWD}")"
export RUSH_PACKAGE_NAME
