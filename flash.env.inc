#!/bin/bash

readonly __script_dir__=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly __root_dir__=$__script_dir__/../../

SNAPSHOT_DIR=$__root_dir__/snapshot
MOSFET_PIN=11
POWER_PLUG_HOST="http://192.168.4.16/cm"
UHUBCTL_DEVICE="1-1"
UHUBCTL_PORT="2"
