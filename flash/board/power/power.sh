#!/usr/bin/env bash
set -euo pipefail
readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

USB="${OPENCCA_USB_SCRIPT:-power_usb_gerneic.sh}"
PLUG="${OPENCCA_PLUG_SCRIPT:-power_plug_tasmota.sh}"
POWER_REBOOT_DELAY="${OPENCCA_POWER_REBOOT_DELAY:-3}"

cd $SCRIPT_DIR

for script in "$USB" "$PLUG"; do
    if [[ ! -x "$script" ]]; then
        echo "Error: Required script '$script' is missing or not executable."
        exit 1
    fi
done

function power_on() {
    bash "$PLUG" on
    bash "$USB" on
}

function power_off() {
    bash "$USB" off
    bash "$PLUG" off
}

function power_reboot() {
    power_off

    # XXX: Depending on the usb dock, we may have to sleep longer
    #      because power is cut in a delayed matter.
    sleep $POWER_REBOOT_DELAY
    
    power_on
}

function print_usage() {
    echo "Usage: $0 {on|off|reboot}"
    exit 1
}

case "$1" in
    on) power_on ;;
    off) power_off ;;
    reboot) power_reboot ;;
    *) print_usage ;;
esac