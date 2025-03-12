set -euo pipefail

readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

readonly VENV_DIR="$SCRIPT_DIR/venv"
readonly INSTALL_SCRIPT="$SCRIPT_DIR/setup_python.sh"

function setup_venv() {
    if [[ ! -d "$VENV_DIR" ]]; then
        echo "INFO: 'venv' folder does not exist. Installing dependencies..."
        bash "$INSTALL_SCRIPT"
    fi
    source "$VENV_DIR/bin/activate"
}

cd $SCRIPT_DIR
setup_venv
python maskrom.py