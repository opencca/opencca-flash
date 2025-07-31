#!/bin/bash
set -euo pipefail

readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

readonly VENV_DIR="$SCRIPT_DIR/venv"
readonly INSTALL_SCRIPT="$SCRIPT_DIR/setup_python.sh"
export PYTHONUNBUFFERED=1

function setup_venv() {
    if [[ ! -d "$VENV_DIR" ]]; then
        echo "INFO: 'venv' folder does not exist. Installing dependencies... into $VENV_DIR"
        bash "$INSTALL_SCRIPT"
    fi
    source "$VENV_DIR/bin/activate"
}

cd $SCRIPT_DIR
setup_venv
echo "Running maskrom.py $@ ..."
python maskrom.py $@