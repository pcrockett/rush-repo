# shellcheck shell=bash

INSTALL_PREFIX="${INSTALL_PREFIX:-"${HOME}/.local/bin"}"
mkdir --parent "${INSTALL_PREFIX}"
