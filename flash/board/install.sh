#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# ROOT_DIR=$SCRIPT_DIR/../

python -m venv venv || true
source ./venv/bin/activate
pip install -r ./requirements.txt || true
