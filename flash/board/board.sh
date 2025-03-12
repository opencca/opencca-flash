#!/usr/bin/env bash
#
# Board control
# This exposes all power and maskrom functionality
#
set -euo pipefail

readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly BOARD_POWER="$SCRIPT_DIR/power/power.sh"
readonly BOARD_MASKROM="$SCRIPT_DIR/maskrom/maskrom.sh"

function enable_verbose_output {
    GRAY='\033[90m'
    RESET='\033[0m'

    exec 3>&1 4>&2  # Save original stdout and stderr
    exec > >(awk '{print "'"$GRAY"'" $0 "'"$RESET"'"}') 2>&1
}

function disable_verbose_output { exec 1>&3 2>&4; }

function board_off {
    echo "Turning off board..."

    enable_verbose_output
    bash "$BOARD_POWER" off    
    disable_verbose_output
}

function board_on {
    echo "Turning on board..."

    enable_verbose_output
    bash "$BOARD_POWER" on
    disable_verbose_output
}

function board_reboot { board_off; sleep 1; board_on; }

function run_maskrom_sequence() {
    board_off

    echo "Pressing Maskrom button..."
    
    enable_verbose_output
    nohub bash "$BOARD_MASKROM" && disable_verbose_output &

    sleep 2
    board_on
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
