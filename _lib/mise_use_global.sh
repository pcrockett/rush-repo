# shellcheck shell=bash

# run `mise use --global` in a temp directory, to prevent any local config files from
# messing with global config
mise_use_global() {
  local temp_dir status
  temp_dir="$(mktemp_dir)"
  pushd "${temp_dir}" &>/dev/null || panic "unable to cd to ${temp_dir}"
  if mise use --global "$@"; then
    status=0
  else
    status=$?
  fi
  popd &>/dev/null || panic "unable to cd AWAY from ${temp_dir}"
  rm -rf "${temp_dir}"
  return ${status}
}
