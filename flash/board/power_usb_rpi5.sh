#!/usr/bin/env bash
set -euo pipefail
readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

#
# On rpi5, there is no individual power management.
# We can only disable all together.
#
# https://github.com/mvp/uhubctl?tab=readme-ov-file#raspberry-pi-5
#

function power_on() {  
  sudo uhubctl -l 2 -a 1
  sudo uhubctl -l 4 -a 1
}

function power_off() {
  sudo uhubctl -l 2 -a 0
  sudo uhubctl -l 4 -a 0
}

set +u
if [[ "$1" == "on" ]]; then
  power_on
elif [[ "$1" == "off" ]]; then
  power_off
else
  echo "Usage: $0 {on|off}"
  exit 1
fi
