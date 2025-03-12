#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
set -euo pipefail
NAME=opencca

docker rm $NAME || true
docker ps --all || true