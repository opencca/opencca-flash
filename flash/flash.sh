#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR=$SCRIPT_DIR/../../

SNAPSHOT_DEF=$ROOT_DIR/snapshot
SNAPSHOT_DIR="${SNAPSHOT_DIR:-$SNAPSHOT_DEF}"
RKDEVELOP_TOOL="${RKDEVELOP_TOOL:-sudo rkdeveloptool}"
BOARD_CTRL=$SCRIPT_DIR/board/board.sh
MINICOM_SCRIPT=$SCRIPT_DIR/minicom.sh


if [[ -f "${SCRIPT_DIR}/flash.env" ]]; then
    echo "Sourcing ${SCRIPT_DIR}/flash.env ..."
    set -x
    source "${SCRIPT_DIR}/flash.env"
    set +x
fi


readonly CMD=$RKDEVELOP_TOOL
readonly CURR_DIRNAME=$(basename `pwd`)


function board_reboot {
    $BOARD_CTRL off
    sleep 1
    $BOARD_CTRL on
}

function board_on {
    $BOARD_CTRL on
}

function board_off {
    $BOARD_CTRL off
}

function board_maskrom {
    $BOARD_CTRL maskrom
}

function minicom {
    echo "Launching minicom..."
    sleep 1
    bash $MINICOM_SCRIPT
}

function enter_maskrom {
    #
    # no need if we are already in maskrom mode
    #
    if $CMD ld | grep -iq "maskrom"; then
            return 0
    fi
    board_maskrom
}

function wait_for_device_or_die {
    local found=0
    local timeout=60
    local start_time=$(date +%s)
    local curr_time=0
    local curr_iter=1

    enter_maskrom

    while true; do
        if $CMD ld | grep -iq "maskrom"; then
            return 0
        fi
    

        curr_time=$(date +%s)
        elapsed_time=$((curr_time - start_time))

        if [[ $elapsed_time -ge $timeout ]]; then
            echo "Timeout reached without finding the string."
            break
        fi
        sleep 0.5
        echo "Waiting for device to enter maskrom mode ($curr_iter/$timeout) ..."
	curr_iter=$((curr_iter + 1))
    done

    exit 1
}


function transfer_loader {
    local cwd=$PWD

    cd $SNAPSHOT_DIR    
    $CMD db ./rk3588_spl_loader_v1.08.111.bin
    cd $cwd
}


function flash_spi {
    local cwd=$PWD
    wait_for_device_or_die


    cd $SNAPSHOT_DIR
    
    set -x
    transfer_loader
    $CMD wl 0 ./u-boot-rockchip-spi.bin 
    $CMD rd
    
    cd $cwd
}

function flash_mmc {
    local cwd=$PWD
    wait_for_device_or_die

    cd $SNAPSHOT_DIR

    set -x
    transfer_loader
    $CMD wl 0x40 ./idbloader.img
    $CMD wl 0x4000 ./u-boot.itb
    $CMD rd

    cd $cwd
}


function clear_flash {
    local cwd=$PWD
    wait_for_device_or_die

    cd $SNAPSHOT_DIR
    set -x
    transfer_loader
    $CMD ef
    cd $cwd
    
}

function show_device {
    local cwd=$PWD
    
    wait_for_device_or_die
    cd $SNAPSHOT_DIR
    
    set -x
    transfer_loader
    $CMD ld

    cd $cwd
}


function print_help() {
    echo "Usage: $0 <command>"
    echo "Commands:"
    echo "  spi       - Flash via SPI"
    echo "  mmc       - Flash via MMC"
    echo "  clear     - Clear the SPI flash memory"
    echo "  maskrom   - Put device into maskrom mode and flash memory driver."
    echo "  device    - Put device into maskrom mode but do not flash memory driver."
    echo "  on        - Power on the board"
    echo "  off       - Power off the board"
    echo "  reboot    - Reboot the board"
    echo "  minicom   - Connect to board with ttyusb"
    echo "  help      - Show this help message"
}    


set +u
# "${@:2}"
case "$1" in
    spi)
        flash_spi
        ;;
    mmc)
        flash_mmc
        ;;
    clear)
        clear_flash
        ;;
    device)
        wait_for_device_or_die
	$RKDEVELOP_TOOL ld
        ;;
   maskrom)
        show_device
        ;;
    on)            
        board_on
        ;;
    off)            
        board_off
        ;;
    reboot)            
        board_reboot
        ;;
    minicom)
	minicom
	;;
    *)
        print_help
esac





