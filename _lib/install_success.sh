# shellcheck shell=bash

install_success() {
    local installed_packages_dir
    local version="${1:-}"
    installed_packages_dir="$(repo_state_dir)/installed_packages"
    mkdir --parent "${installed_packages_dir}"
    if [ "${version}" == "" ]; then
        touch "${installed_packages_dir}/${RUSH_PACKAGE_NAME}"
    else
        echo "${version}" > "${installed_packages_dir}/${RUSH_PACKAGE_NAME}"
    fi
}
