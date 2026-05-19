# shellcheck shell=bash

is_deb_system() {
  command_exists dpkg apt-get
}
