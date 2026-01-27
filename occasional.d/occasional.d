#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Execute scripts in occasional.d directories

Usage: occasional.d TIME_INTERVAL [flags...]

Arguments:

    TIME_INTERVAL: minute|hour|day|week|month

Flags:

    --enable: Activate the systemd timer for the given interval
    --disable: Deactivate the systemd timer for the given interval

Example usage:

    # execute scripts in ~/.config/occasional.d/hour
    occasional.d hour

    # execute global scripts in /etc/occasional.d/day
    sudo occasional.d day

EOF
}

panic() {
  echo "FATAL: $*" >&2
  exit 1
}

# shellcheck disable=SC2329  # this function is doch called below, just via a dynamically-called function
unbuffer_output() {
  stdbuf --output L --error L "$@"
}

init() {
  TIME_INTERVAL="${1:-}"
  shift 1

  case "${TIME_INTERVAL}" in
    minute | hour | day | week | month)
      true # input looks good, carry on
      ;;
    *)
      echo "ERROR: Must specify one of minute, hour, day, week, or month as first argument"
      usage
      exit 1
      ;;
  esac

  OPERATION="run"
  while [ "${#@}" -gt 0 ]; do
    case "${1}" in
      --enable)
        OPERATION="enable"
        ;;
      --disable)
        OPERATION="disable"
        ;;
      *)
        echo "ERROR: Unrecognized argument: ${1}"
        usage
        exit 1
        ;;
    esac
    shift 1
  done

  if [ "$(id --user)" -eq 0 ]; then
    cd / || panic "unable to cd to /"
    XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"/etc"}"
  else
    cd "${HOME}" || panic "unable to cd to \$HOME (${HOME})"
    XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
  fi

  OCCASIONAL_CONFIG_DIR="${XDG_CONFIG_HOME}/occasional.d"

  if [ "$(id --user)" -eq 0 ]; then
    SYSTEMCTL_CMD=(systemctl)
  else
    SYSTEMCTL_CMD=(systemctl --user)
  fi
}

# shellcheck disable=SC2329  # function invoked indirectly
operation:enable() {
  "${SYSTEMCTL_CMD[@]}" enable --now "occasional.d-${TIME_INTERVAL}.timer"
}

# shellcheck disable=SC2329  # function invoked indirectly
operation:disable() {
  "${SYSTEMCTL_CMD[@]}" disable --now "occasional.d-${TIME_INTERVAL}.timer"
}

# shellcheck disable=SC2329  # function invoked indirectly
operation:run() {
  export OCCASIONAL_EXIT_SUCCESS=0
  export OCCASIONAL_EXIT_ERROR_FATAL=1
  export OCCASIONAL_EXIT_ERROR_NONFATAL=2
  EXIT_CODE=${OCCASIONAL_EXIT_SUCCESS}

  scripts_to_run="$(
    find "${SCRIPT_DIR}" -maxdepth 1 -mindepth 1 -executable -type f -print0 \
      | xargs -0 -L 1 basename \
      | sort
  )"

  echo "Will run the following scripts:"
  # shellcheck disable=SC2016  # dollar sign intentionally in single quotes
  echo "${scripts_to_run}" | unbuffer_output awk '{print "-> " $0}'

  while read -r script; do
    echo "Starting: ${script}"
    if unbuffer_output "${SCRIPT_DIR}/${script}"; then
      echo "SUCCESS: exited with code $?: ${script}"
    else
      result=$?
      if [ "${result}" -eq "${OCCASIONAL_EXIT_ERROR_NONFATAL}" ]; then
        echo "ERROR (nonfatal): exited with code ${result}: ${script}"
        EXIT_CODE="${OCCASIONAL_EXIT_ERROR_NONFATAL}"
      else
        echo "ERROR: exited with code ${result}: ${script}"
        return "${result}"
      fi
    fi
  done < <(echo "${scripts_to_run}")

  echo "Finished executing scripts."
  return "${EXIT_CODE}"
}

main() {
  init "$@"
  SCRIPT_DIR="${OCCASIONAL_CONFIG_DIR}/${TIME_INTERVAL}"

  (
    umask u=rwx,g=,o= # restrict permissions so it's safe to hard-code secrets in scripts
    mkdir --parent "${SCRIPT_DIR}"
  )
  test -d "${SCRIPT_DIR}" || panic "Not a directory: ${SCRIPT_DIR}"
  "operation:${OPERATION}"
  exit $?
}

main "$@"
