#!/usr/bin/env bash
set -euo pipefail
readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

UHUBCTL_DEVICE="${UHUBCTL_DEVICE:-1-1}"
UHUBCTL_PORT="${UHUBCTL_PORT:-2}"

function power_on() {  
  sudo uhubctl -l "$UHUBCTL_DEVICE" -p "$UHUBCTL_PORT" -a on
}

function power_off() {
    sudo uhubctl -l "$UHUBCTL_DEVICE" -p "$UHUBCTL_PORT" -a off || true
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
