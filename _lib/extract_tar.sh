# shellcheck shell=bash

extract_tar_gz_url() {
  local src_url="${1}"
  shift
  local dest="${1}"
  shift
  local tar_args=("$@")
  local temp_dir
  temp_dir="$(mktemp_dir)"
  __extract_tar_gz_url_cleanup() {
    local exit_code=$?
    rm -rf "${temp_dir}"
    return $exit_code
  }

  {
    curl_download "${src_url}" >"${temp_dir}/archive"
    extract_tar_gz "${temp_dir}/archive" "${dest}" "${tar_args[@]}"
  } || __extract_tar_gz_url_cleanup
  __extract_tar_gz_url_cleanup
}

extract_tar_gz() {
  local archive_path="${1}"
  shift
  local dst_path="${1}"
  shift
  local tar_args=("$@")

  rm -rf "${dst_path}.new"
  mkdir --parent "${dst_path}.new"
  tar --directory "${dst_path}.new" -xzf "${archive_path}" "${tar_args[@]}"

  rm -rf "${dst_path}.old"
  test ! -d "${dst_path}" || mv "${dst_path}" "${dst_path}.old"

  mv "${dst_path}.new" "${dst_path}"
}
