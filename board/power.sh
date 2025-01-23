#!/usr/bin/env bash
set -euo pipefail
readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

USB=$SCRIPT_DIR/power_usb.sh
PLUG=$SCRIPT_DIR/power_plug.sh

set +u
if [[ "$1" == "on" ]]; then
    $PLUG on
    $USB on
elif [[ "$1" == "off" ]]; then
    $USB off
    $PLUG off
elif [[ "$1" == "reboot" ]]; then
    $USB off
    $PLUG off
    sleep 1
    $PLUG on
    $USB on
else
  echo "Usage: $0 {on|off|reboot}"
  exit 1
fi
