#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -x

$SCRIPT_DIR/power.sh off
python $SCRIPT_DIR/gpio-maskrom.py &
sleep 2
$SCRIPT_DIR/power.sh on
