#!/usr/bin/env bats

source _tests/util.sh

@test 'install_success - simple package name - creates marker file' {
    mkdir -p "${RUSH_REPO_DIR}/test"
    cat > "${RUSH_REPO_DIR}/test/main" <<'EOF'
#!/usr/bin/env bash

# shellcheck source=lib.sh
source "${REPO_PATH}/lib.sh"
install_success
EOF
    capture_output rush get test
    assert_no_stderr
    assert_exit_code 0

    marker_file="${XDG_STATE_HOME}/rush/pcrockett/installed_packages/test"
    test -f "${marker_file}" || fail "does not exist: ${marker_file}"
}

@test 'install_success - nested package name - creates marker file' {
    mkdir -p "${RUSH_REPO_DIR}/test/subdir"
    cat > "${RUSH_REPO_DIR}/test/subdir/main" <<'EOF'
#!/usr/bin/env bash

# shellcheck source=lib.sh
source "${REPO_PATH}/lib.sh"
install_success
EOF
    capture_output rush get test/subdir
    assert_no_stderr
    assert_exit_code 0

    marker_file="${XDG_STATE_HOME}/rush/pcrockett/installed_packages/test/subdir"
    test -f "${marker_file}" || fail "does not exist: ${marker_file}"
}
