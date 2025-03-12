#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BOARD_DIR=$SCRIPT_DIR

BOARD_ON="$BOARD_DIR/power.sh on"
BOARD_OFF="$BOARD_DIR/power.sh off"
BOARD_MASKROM="$BOARD_DIR/maskrom.sh"

function board_reboot {
    bash $BOARD_OFF
    sleep 1
    bash $BOARD_ON
}

function board_on {
    bash $BOARD_ON
}

function board_off {
    bash $BOARD_OFF
}

function board_maskrom { 
    bash $BOARD_MASKROM
}

set +u

case "$1" in
    on)            
        board_on
        ;;
    off)            
        board_off
        ;;
    reboot)            
        board_reboot
        ;;
    maskrom)            
        board_maskrom
        ;;
    *)
        echo "Usage: $0 {on|off|reboot|maskrom}"
esac


