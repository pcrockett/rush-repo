# shellcheck shell=bash

install_success() {
    local installed_packages_dir
    local version="${1:-}"
    installed_packages_dir="$(repo_state_dir)/installed_packages"
    package_marker_file="${installed_packages_dir}/${RUSH_PACKAGE_NAME}"

    # for the following it's important to remember that ${RUSH_PACKAGE_NAME} may be a
    # nested package, i.e. `foo/bar`
    package_marker_dir="$(dirname "${package_marker_file}")"
    mkdir --parent "${package_marker_dir}"

    if [ "${version}" == "" ]; then
        touch "${package_marker_file}"
    else
        echo "${version}" > "${package_marker_file}"
    fi
}
