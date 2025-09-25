# shellcheck shell=bash

uninstall_success() {
  local installed_packages_dir
  installed_packages_dir="$(repo_state_dir)/installed_packages"
  rm -f "${installed_packages_dir}/${RUSH_PACKAGE_NAME}"
}
