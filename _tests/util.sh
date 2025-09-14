# shellcheck shell=bash

setup() {
    set -euo pipefail

    TEST_HOME="$(mktemp --directory --tmpdir=/tmp bats-home.XXXXXX)"
    export HOME="${TEST_HOME}"
    export RUSH_ROOT="${TEST_HOME}/rush"
    export RUSH_CONFIG="${TEST_HOME}/rush-config"
    export XDG_STATE_HOME="${TEST_HOME}/.local/state"
    export XDG_DATA_HOME="${TEST_HOME}/.local/share"
    export XDG_CONFIG_HOME="${TEST_HOME}/.config"
    export XDG_CACHE_HOME="${TEST_HOME}/.cache"

    RUSH_REPO_DIR="${RUSH_ROOT}/pcrockett/rush-repo"
    mkdir -p "${TEST_HOME}/.local/bin" "${RUSH_REPO_DIR}"
    PATH="${TEST_HOME}/.local/bin:${PATH}"
    cp -r lib.sh _lib "${RUSH_REPO_DIR}"
    echo "default = ${RUSH_REPO_DIR}" > "${RUSH_CONFIG}"

    TEST_CWD="$(mktemp --directory --tmpdir=/tmp bats-test.XXXXXX)"
    cp .tool-versions "${TEST_CWD}"
    cd "${TEST_CWD}"
}

teardown() {
    rm -rf "${TEST_CWD}"
    rm -rf "${TEST_HOME}"
}

fail() {
    echo "${*}"
    exit 1
}

# shellcheck disable=SC2034  # this function returns data via variables
capture_output() {
    local stderr_file stdout_file
    stderr_file="$(mktemp)"
    stdout_file="$(mktemp)"
    capture_exit_code "${@}" \
        > "${stdout_file}" \
        2> "${stderr_file}"
    TEST_STDOUT="$(cat "${stdout_file}")"
    TEST_STDERR="$(cat "${stderr_file}")"
    rm -f "${stdout_file}" "${stderr_file}"
}

# shellcheck disable=SC2034  # this function returns data via variables
capture_exit_code() {
    if "${@}"; then
        TEST_EXIT_CODE=0
    else
        TEST_EXIT_CODE=$?
    fi
}

assert_exit_code() {
    test "${TEST_EXIT_CODE}" -eq "${1}" \
        || fail "Expected exit code ${1}; got ${TEST_EXIT_CODE}"
}

assert_stdout() {
    if ! [[ "${TEST_STDOUT}" =~ ${1} ]]; then
        printf "******STDOUT:******\n%s\n*******************\n" "${TEST_STDOUT}"
        printf "*****EXPECTED:*****\n%s\n*******************\n" "${1}"
        fail "stdout didn't match expected."
    fi
}

assert_no_stdout() {
    if [ "${TEST_STDOUT}" != "" ]; then
        printf "******STDOUT:******\n%s\n*******************\n" "${TEST_STDOUT}"
        fail "stdout is expected to be empty."
    fi
}

assert_stderr() {
    if ! [[ "${TEST_STDERR}" =~ ${1} ]]; then
        printf "******STDERR:******\n%s\n*******************\n" "${TEST_STDERR}"
        printf "*****EXPECTED:*****\n%s\n*******************\n" "${1}"
        fail "stderr didn't match expected."
    fi
}

assert_no_stderr() {
    if [ "${TEST_STDERR}" != "" ]; then
        printf "******STDERR:******\n%s\n*******************\n" "${TEST_STDERR}"
        fail "stderr is expected to be empty."
    fi
}
