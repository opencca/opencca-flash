#!/bin/bash

# Wrapper for opencca container
# ./run.sh: ..........Enter container
# ./run.sh <command>: execute command right away
#
readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
set -euo pipefail

PROJ_DIR=$SCRIPT_DIR/../../
MOUNT_DIR=/opencca
WORK_DIR=/opencca/flash


CONTAINER=opencca-flashserver:latest
NAME="opencca"
HOSTNAME="opencca_docker"

SHELL=/bin/fish


# XXX: --priviledged and -v /dev
# We manage usb device from within docker container
docker run \
    --privileged  \
    --network=host \
    --name $NAME \
    -v /dev:/dev \
    -v "$PROJ_DIR:$MOUNT_DIR" \
    -w $WORK_DIR \
    --hostname $HOSTNAME \
    --add-host "$HOSTNAME=127.0.0.1" \
    -it -d $CONTAINER $SHELL || true


docker start $NAME || true

CMD=${@:-}
if [ -z "$CMD" ]; then
    docker attach $NAME
else
    docker exec -it $NAME $CMD
fi
