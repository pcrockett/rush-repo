# shellcheck shell=bash

mktemp_dir() {
  mktemp --directory --tmpdir "pcrockett_rush.XXXX"
}
