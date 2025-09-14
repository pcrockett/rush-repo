#!/usr/bin/env bats

source _tests/util.sh

init_package() {
    local package_name="${1:?Must specify a package name}"
    local package_body="${2:-install_success}"
    mkdir -p "${RUSH_REPO_DIR}/${package_name}"
    cat > "${RUSH_REPO_DIR}/${package_name}/main" <<EOF
#!/usr/bin/env bash

# shellcheck source=lib.sh
source "\${REPO_PATH}/lib.sh"
${package_body}
EOF
    chmod +x "${RUSH_REPO_DIR}/${package_name}/main"
}

@test 'installed_package_names - many packages - lists all packages' {
    # create and install some dummy packages
    for p in test1 test2 test3/subdir;
    do
        init_package "${p}"
        capture_output rush get "${p}"
        assert_no_stderr
        assert_exit_code 0
    done

    # create a package that just lists installed package names on stderr
    init_package package_names "installed_package_names >&2"

    # only installed package names should come out on stderr
    capture_output rush get package_names
    assert_stderr \
'^test1
test2
test3/subdir$'
    assert_exit_code 0
}
