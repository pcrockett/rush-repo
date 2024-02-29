# shellcheck shell=bash

install_success() {
    local installed_packages_dir
    installed_packages_dir="$(repo_state_dir)/installed_packages"
    mkdir --parent "${installed_packages_dir}"
    touch "${installed_packages_dir}/${RUSH_PACKAGE_NAME}"
}
