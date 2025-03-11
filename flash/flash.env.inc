#!/bin/bash

readonly __script_dir__=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly __root_dir__=$__script_dir__/../../

export SNAPSHOT_DIR=$__root_dir__/snapshot
export MOSFET_PIN=11
export POWER_PLUG_HOST="http://192.168.4.16/cm"
export UHUBCTL_DEVICE="1-1"
export UHUBCTL_PORT="2"
export TTYUSB=/dev/ttyUSB0
