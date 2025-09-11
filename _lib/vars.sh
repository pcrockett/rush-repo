# shellcheck shell=bash

export XDG_STATE_HOME="${XDG_STATE_HOME:-"${HOME}/.local/state"}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}/.local/share"}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-"${HOME}/.cache"}"

RUSH_GLOBAL_BIN="${RUSH_GLOBAL_BIN:-"/usr/local/bin"}"

if [ "$(id --user)" -eq 0 ]; then
    # generally speaking you shouldn't run rush as root (at least for this repo)
    # however there are times when you want to, such as when building a docker
    # image with the [`yolo`](https://philcrockett.com/yolo/v1.sh) script.
    #
    # in this case it makes more sense to install these tools globally by default,
    # rather than in `/root/.local/bin`.
    RUSH_USER_BIN="${RUSH_USER_BIN:-${RUSH_GLOBAL_BIN}}"
else
    RUSH_USER_BIN="${RUSH_USER_BIN:-"${HOME}/.local/bin"}"
fi

# explanation for parameter expansion: <https://stackoverflow.com/a/25725435/138757>
# given these paths:
#
# * stringA: /a/b/c/d
# * stringB: /a/b
#
# then ${stringA#"${stringB}"} returns /c/d
RUSH_PACKAGE_NAME="${PWD#"${REPO_PATH}"}"
export RUSH_PACKAGE_NAME
