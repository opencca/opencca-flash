#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR=$SCRIPT_DIR/

function source_env {
    if [[ -f "${SCRIPT_DIR}/.env" ]]; then
        echo "Sourcing ${SCRIPT_DIR}/.env..."
        source "${SCRIPT_DIR}/.env"
    fi

    echo -e "\033[34m======== OpenCCA ENV ========"
    env | grep -v "LS_COLORS" | grep OPENCCA
    echo -e "======== OpenCCA ENV ======== \033[0m"
}

# Source env for definitions
source_env

SNAPSHOT_DIR="${OPENCCA_SNAPSHOT_DIR:-$ROOT_DIR/snapshot}"
RKDEVELOP_TOOL="${OPENCCA_RKDEVELOP_TOOL:-sudo $ROOT_DIR/tools/rkdeveloptool}"
CMD=$RKDEVELOP_TOOL

BOARD_CTRL=$SCRIPT_DIR/board/board.sh
MINICOM_SCRIPT=$SCRIPT_DIR/minicom.sh

function verbose_output {
    GRAY='\033[90m'
    RESET='\033[0m'

    exec 3>&1 4>&2 
    exec > >(awk '{print "'"$GRAY"'" $0 "'"$RESET"'"}') 2>&1 
    set -x
}

function verbose_reset {
    set +x
    exec 1>&3 2>&4
}

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
    verbose_output

    transfer_loader
    $CMD wl 0 ./u-boot-rockchip-spi.bin 
    $CMD rd

    verbose_reset
    cd $cwd
}

function flash_mmc {
    local cwd=$PWD
    wait_for_device_or_die

    cd $SNAPSHOT_DIR
    verbose_output

    transfer_loader
    $CMD wl 0x40 ./idbloader.img
    $CMD wl 0x4000 ./u-boot.itb
    $CMD rd

    verbose_reset
    cd $cwd
}


function clear_flash {
    local cwd=$PWD
    wait_for_device_or_die

    cd $SNAPSHOT_DIR
    verbose_output

    transfer_loader
    $CMD ef

    verbose_reset
    cd $cwd
    
}

function show_device {
    local cwd=$PWD
    
    wait_for_device_or_die
    cd $SNAPSHOT_DIR
    verbose_output

    transfer_loader
    $CMD ld

    verbose_reset
    cd $cwd
}


function print_help() {
    echo "Usage: $0 <command>"
    echo "Commands:"
    echo "  spi                   - Flash via SPI"
    echo "  mmc                   - Flash via MMC"
    echo "  clear                 - Clear the SPI flash memory"
    echo "  maskrom               - Put device into maskrom mode and flash memory driver."
    echo "  device                - Put device into maskrom mode but do not flash memory driver."
    echo "  on                    - Power on the board"
    echo "  off                   - Power off the board"
    echo "  reboot                - Reboot the board"
    echo "  minicom               - Connect to board with ttyusb"
    echo "  rkdeveloptool <args>  - Run rkdeveloptool"
    echo "  help                  - Show this help message"
}    

set +u
echo "Executing command: $1 ..."
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
    rkdeveloptool)
        $CMD "${@:2}"
        ;;
    *)
        print_help
esac





