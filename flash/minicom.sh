#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

set -x
DEV=/dev/ttyUSB0
OPENCCA_TTYUSB="${OPENCCA_TTYUSB:-$DEV}"
#
# XXX: Write to user directory is ugly, we leave it as is for now
#
CONFIG_FILE=$HOME/.minirc.rock5
echo "creating config file $CONFIG_FILE"

cat > $CONFIG_FILE <<- CMD
pu baudrate         1500000
pu bits             8
pu parity           N
pu stopbits         1
pu rtscts           No
CMD


minicom -w -t xterm -l -R UTF-8 -D $OPENCCA_TTYUSB rock5 -C $SCRIPT_DIR/minicom.txt -o
