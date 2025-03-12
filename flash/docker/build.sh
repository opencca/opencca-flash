#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
set -euo pipefail
CONTAINER=opencca-flashserver:latest

$SCRIPT_DIR/./rm.sh || true

docker build -t $CONTAINER .
