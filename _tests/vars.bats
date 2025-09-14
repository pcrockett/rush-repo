#!/usr/bin/env bats

source _tests/util.sh

@test 'RUSH_PACKAGE_NAME - always - relative to repo root' {
    mkdir -p "${RUSH_REPO_DIR}/test"
    cat > "${RUSH_REPO_DIR}/test/main" <<'EOF'
#!/usr/bin/env bash

# shellcheck source=lib.sh
source "${REPO_PATH}/lib.sh"
echo "${RUSH_PACKAGE_NAME}" >&2
EOF
    capture_output rush get test
    assert_stderr "^test$"
}

@test 'RUSH_PACKAGE_NAME - subdirectory - includes all path elements' {
    mkdir -p "${RUSH_REPO_DIR}/test/subdir"
    cat > "${RUSH_REPO_DIR}/test/subdir/main" <<'EOF'
#!/usr/bin/env bash

# shellcheck source=lib.sh
source "${REPO_PATH}/lib.sh"
echo "${RUSH_PACKAGE_NAME}" >&2
EOF
    capture_output rush get test/subdir
    assert_stderr "^test/subdir$"
}
