# shellcheck shell=bash

installed_package_version() {
  local installed_packages_dir
  installed_packages_dir="$(repo_state_dir)/installed_packages"
  if [ -f "${installed_packages_dir}/${RUSH_PACKAGE_NAME}" ]; then
    cat "${installed_packages_dir}/${RUSH_PACKAGE_NAME}"
  fi
}
