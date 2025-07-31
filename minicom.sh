#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

set -x

DEV=/dev/ttyUSB0
OPENCCA_TTYUSB="${OPENCCA_TTYUSB:-$DEV}"
LOCK_FILE="/var/lock/LCK..$(basename "$OPENCCA_TTYUSB")"

if pgrep -x "minicom" > /dev/null; then
    echo "Existing Minicom session detected. Killing..."
    pkill -x minicom
    sleep 1 
fi

if [ -f "$LOCK_FILE" ]; then
    echo "Removing stale lock file: $LOCK_FILE"
    sudo rm -f "$LOCK_FILE"
fi

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


minicom -w -t xterm -l -R UTF-8 -D $OPENCCA_TTYUSB rock5 -C $SCRIPT_DIR/minicom.txt
