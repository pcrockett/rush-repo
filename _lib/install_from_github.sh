# shellcheck shell=bash

install_from_github() {
  local __installed_version \
    __download_url \
    __artifact_name

  __installed_version="$(installed_version)"

  if [ "${__installed_version}" == "" ]; then
    # disable cooldown when installing new packages
    export RUSH_COOLDOWN="0min"
  else
    if ! command -v nu &>/dev/null; then
      log_warning "Cooldown will only be respected if nushell is installed."
      # since cooldown logic is implemented in [ref:github_latest_tag_nu]
    fi
    export RUSH_COOLDOWN="${RUSH_COOLDOWN:-1wk}"
  fi

  GITHUB_LATEST_TAG="$(
    github_latest_tag "${GITHUB_ORG}" "${GITHUB_REPO}"
  )"
  export GITHUB_LATEST_TAG

  if [ "${GITHUB_LATEST_TAG}" == "" ]; then
    log_attention "Skipping update (cooldown ${RUSH_COOLDOWN})"
    return 0
  fi

  GITHUB_LATEST_VERSION="$(latest_version)"
  export GITHUB_LATEST_VERSION

  if [ "${GITHUB_LATEST_VERSION}" == "${__installed_version}" ]; then
    log_attention "Already installed and up-to-date."
    return 0
  fi

  __download_url="$(download_url)"
  __artifact_name="$(artifact_name)"

  temp_dir="$(mktemp_dir)"
  cleanup() {
    local exit_code="${?}"
    popd &>/dev/null || panic "unable to cd away from ${temp_dir}"
    rm -rf "${temp_dir}"
    return "${exit_code}"
  }
  pushd "${temp_dir}" &>/dev/null || cleanup

  log_info "Download ${__download_url} to ${temp_dir}/${__artifact_name}..."
  download_artifact "${__download_url}" "${temp_dir}/${__artifact_name}" || cleanup

  log_info "Installing..."
  ARTIFACT_PATH="${temp_dir}/${__artifact_name}" \
    install_artifact || cleanup

  log_attention "Done."
  cleanup
}
