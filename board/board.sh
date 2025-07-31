#!/usr/bin/env bash
#
# Board control
# This exposes all power and maskrom functionality
#
set -euo pipefail

readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly BOARD_POWER="$SCRIPT_DIR/power/power.sh"
readonly BOARD_MASKROM="$SCRIPT_DIR/maskrom/maskrom.sh"

OPENCCA_MASKROM_RELEASE_DELAY="${OPENCCA_MASKROM_RELEASE_DELAY:-3}"

function board_power { 
    # XXX: Ensure that button is never pressed upon
    #      power change.
    bash "$BOARD_MASKROM" release

    bash "$BOARD_POWER" $1;    
}

function run_maskrom_sequence() {
    echo "Pressing Maskrom button..."
    bash "$BOARD_MASKROM" press

    bash "$BOARD_POWER" reboot;

    sleep $OPENCCA_MASKROM_RELEASE_DELAY
    bash "$BOARD_MASKROM" release
}

function board_control() {
    case "$1" in
        off|on|reboot) board_power $1 ;;
        maskrom) run_maskrom_sequence ;;
        *) echo "Usage: $0 {on|off|reboot|maskrom}" && exit 0 ;;
    esac
}

board_control "${1:-}"
