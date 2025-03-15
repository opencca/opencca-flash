#!/usr/bin/env bash
#
# Board control
# This exposes all power and maskrom functionality
#
set -euo pipefail

readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly BOARD_POWER="$SCRIPT_DIR/power/power.sh"
readonly BOARD_MASKROM="$SCRIPT_DIR/maskrom/maskrom.sh"

function board_power { bash "$BOARD_POWER" $1; }

function run_maskrom_sequence() {
    echo "Pressing Maskrom button..."
    bash "$BOARD_MASKROM" press

    board_power reboot

    sleep 7 
    bash "$BOARD_MASKROM" release
}

function board_control() {
    case "$1" in
        off|on|reboot) board_power $1 ;;
        maskrom) run_maskrom_sequence ;;
        *) echo "Usage: $0 {on|off|reboot|maskrom}" && exit 1 ;;
    esac
}

board_control "${1:-}"
