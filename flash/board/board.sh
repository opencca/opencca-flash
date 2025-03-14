#!/usr/bin/env bash
#
# Board control
# This exposes all power and maskrom functionality
#
set -euo pipefail

readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly BOARD_POWER="$SCRIPT_DIR/power/power.sh"
readonly BOARD_MASKROM="$SCRIPT_DIR/maskrom/maskrom.sh"

function board_off { bash "$BOARD_POWER" off; }
function board_on { bash "$BOARD_POWER" on;  }

# XXX: In case device does not reboot but remains in
#      maskrom mode than sleep between off and on is too little
function board_reboot { echo "rebooting"; board_off; sleep 3; board_on; }

function run_maskrom_sequence() {
    board_off

    echo "Pressing Maskrom button..."
    bash "$BOARD_MASKROM" press
    sleep 2
    board_on
    sleep 5
    bash "$BOARD_MASKROM" release
}

function board_control() {
    set +u
    case "$1" in
        on) board_on ;;
        off) board_off ;;
        reboot) board_reboot ;;
        maskrom) run_maskrom_sequence ;;
        *) echo "Usage: $0 {on|off|reboot|maskrom}" && exit 1 ;;
    esac
}

board_control "$1"
