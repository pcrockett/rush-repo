# shellcheck shell=bash

installed_package_names() {
    local state_dir
    state_dir="$(repo_state_dir)"
    local installed_packages_dir="${state_dir}/installed_packages"
    __marker_file_to_package_name() {
        # expects a list of marker files on stdin
        # outputs the package name for each marker file on stdout
        while read -r dir;
        do
            echo "${dir#"${installed_packages_dir}/"}"
        done
    }
    find "${installed_packages_dir}" -type f | sort | __marker_file_to_package_name
}
