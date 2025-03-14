#!/usr/bin/env bash
set -euo pipefail
#
# opencca flash server:
# This is the main script to interact with board
# for firmware flashing and power management.
#
readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR=$SCRIPT_DIR/

# Set to 1 to debug this script
PRINT_DEBUG=0

function source_env {
    if [[ -f "${SCRIPT_DIR}/.env" ]]; then
        echo "Sourcing ${SCRIPT_DIR}/.env..."
        source "${SCRIPT_DIR}/.env"
    fi
    echo -e "\033[34m======== OpenCCA ENV ========"
    env | grep -v "LS_COLORS" | grep OPENCCA | sort
    echo -e "======== OpenCCA ENV ======== \033[0m"
}

#
# Env variables
#
source_env 
SNAPSHOT_DIR="${OPENCCA_SNAPSHOT_DIR:-$ROOT_DIR/snapshot}"
RKDEVELOP_TOOL="${OPENCCA_RKDEVELOP_TOOL:-sudo $ROOT_DIR/tools/rkdeveloptool}"
OPENCCA_SPL_LOADER="${OPENCCA_SPL_LOADER:-$ROOT_DIR/tools/rk3588/rk3588_spl_loader_v1.08.111.bin}"
CMD=$RKDEVELOP_TOOL

BOARD_CTRL=$SCRIPT_DIR/board/board.sh
MINICOM_SCRIPT=$SCRIPT_DIR/minicom.sh

#
# Commands
# 
function cmd_print_help {
    cat <<EOF
Usage: $0 <command>
Commands:
  spi                   - Flash via SPI
  mmc                   - Flash via MMC
  clear                 - Clear the SPI flash memory
  maskrom               - Put device into Maskrom mode and flash memory driver
  device                - Put device into Maskrom mode but do not flash memory driver
  on                    - Power on the board
  off                   - Power off the board
  reboot                - Reboot the board
  minicom               - Connect to board with ttyusb
  rkdeveloptool <args>  - Run rkdeveloptool with custom arguments
  help                  - Show this help message
EOF
}

function cmd_board_on { echo "Turning on board..."; $BOARD_CTRL on; }
function cmd_board_off { echo "Turning off board..."; $BOARD_CTRL off; }
function cmd_board_reboot { cmd_board_off; sleep 1; cmd_board_on; }
function cmd_board_maskrom { $BOARD_CTRL maskrom; }

function cmd_minicom_connect {
    echo "Launching minicom..."
    sleep 1
    bash $MINICOM_SCRIPT
}

function cmd_flash_spi {
    wait_for_device_or_die
    enable_verbose_output
    transfer_loader

    $CMD wl 0 $SNAPSHOT_DIR/u-boot-rockchip-spi.bin 
    $CMD rd

    disable_verbose_output
}

function cmd_flash_mmc {
    wait_for_device_or_die
    enable_verbose_output
    transfer_loader

    $CMD wl 0x40 $SNAPSHOT_DIR/idbloader.img
    $CMD wl 0x4000 $SNAPSHOT_DIR/u-boot.itb
    $CMD rd

    disable_verbose_output
}

function cmd_clear_flash {
    wait_for_device_or_die
    enable_verbose_output
    transfer_loader

    $CMD ef

    disable_verbose_output
}

function cmd_show_device {    
    wait_for_device_or_die
    enable_verbose_output
    transfer_loader

    disable_verbose_output
    $CMD ld
}

#
# Helpers
# 
function disable_verbose_output { 
    [[ "$PRINT_DEBUG" == "1" ]] && return

    set +x
    exec 1>&3 2>&4;
}

function enable_verbose_output {
    local GRAY='\033[90m'
    local RED='\033[91m'
    local GREEN='\033[92m'
    local RESET='\033[0m'

    [[ "$PRINT_DEBUG" == "1" ]] && return

    exec 3>&1 4>&2  # Save original stdout and stderr
    exec > >(awk '{
        line = $0;
        if (tolower(line) ~ /(warn|error|fail)/) 
            print "'"$RED"'" line "'"$RESET"'";
        else if (tolower(line) ~ /(success|ok)/) 
            print "'"$GREEN"'" line "'"$RESET"'";
        else 
            print "'"$GRAY"'" line "'"$RESET"'";
    }') 2>&1
    set -x
}

function is_in_maskrom { $CMD ld | grep -iq "maskrom"; }

function enter_maskrom {
    if is_in_maskrom; then
        echo "Device already in Maskrom mode."
        return
    fi
    cmd_board_maskrom
}

function wait_for_device_or_die {
    local timeout=60
    local start_time=$(date +%s)

    enter_maskrom

    while ! is_in_maskrom; do
     local elapsed_time=$(( $(date +%s) - start_time ))
        if [[ $elapsed_time -ge $timeout ]]; then
            echo "Timeout reached. Device did not enter Maskrom mode."
            exit 1
        fi
        echo "Waiting for device to enter Maskrom mode... ($elapsed_time/$timeout)"
        sleep 0.5
    done
}

function transfer_loader {
    local cwd=$PWD

    # Do not transfer loader if already transfered
    if $CMD rcb | grep -q "Capability:"; then
        # rcb command will succeed if maskrom dirver 
        # already flashed. we will see something like:
        #   Capability:2F 03 00 00 00 00 00 00 
        #
        echo "Loader already transferred. Skipping."
        return 0
    fi

    cd $SNAPSHOT_DIR
    $CMD db "$OPENCCA_SPL_LOADER"
    cd $cwd
}

#
# Main
# 
[[ "$PRINT_DEBUG" == "1" ]] && set -x
set +u
echo "Executing command: $1 ..."

case "$1" in
    on) cmd_board_on ;;
    off) cmd_board_off ;;
    reboot) cmd_board_reboot ;;
    maskrom) cmd_show_device ;;
    minicom) cmd_minicom_connect ;;
    spi) cmd_flash_spi ;;
    mmc) cmd_flash_mmc ;;
    clear) cmd_clear_flash ;;
    device)
        wait_for_device_or_die
        $CMD ld
        ;;
    rkdeveloptool) $CMD "${@:2}" ;;
    *) cmd_print_help ;;
esac