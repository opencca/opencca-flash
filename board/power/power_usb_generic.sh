#!/usr/bin/env bash
set -euo pipefail

#
# Generic case to toggle a port with uhubctl
#
OPENCCA_USB_DEVICE="${OPENCCA_USB_DEVICE:-1-1}"
OPENCCA_USB_PORT="${OPENCCA_USB_PORT:-2}"

function power_on() {  
  sudo uhubctl -l "$OPENCCA_USB_DEVICE" -p "$OPENCCA_USB_PORT" -a on || true
}

function power_off() {
    sudo uhubctl -l "$OPENCCA_USB_DEVICE" -p "$OPENCCA_USB_PORT" -a off || true
}

set +u
case "$1" in
    on)  power_on ;;
    off) power_off ;;
    *)   echo "Usage: $0 {on|off}"
         exit 1;;
esac

