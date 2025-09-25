# shellcheck shell=bash

force_please() {
  test "${FORCE:-}" != ""
}
