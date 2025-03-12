#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
VENV_DIR=$SCRIPT_DIR/venv


if [ ! -d "$VENV_DIR" ]; then
    echo "INFO: 'venv' folder does not exist in $SCRIPT_DIR."
    echo "Installing dependencies first..."
    $SCRIPT_DIR/install.sh
fi

source "$VENV_DIR/bin/activate"

$SCRIPT_DIR/power.sh off
python $SCRIPT_DIR/gpio-maskrom.py &
sleep 2
$SCRIPT_DIR/power.sh on
