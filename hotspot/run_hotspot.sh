#!/bin/bash

#
# Run opencca hotspot from within a docker container.
# Hotspot is required to control IOT smart plug
#
set -euo pipefail
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
MOUNT_DIR=$SCRIPT_DIR

set -x 
container=opencca-hotspot

docker build -t $container .
docker stop $container || true
docker rm $container || true

#
# XXX: We place .env with wifi details in /config/.env.
#      Host requires NetworkManager and dbus.
#      --privileged required for WIFI management.
docker run --network=host --privileged \
  -v /run/dbus:/host/run/dbus \
  -v $SCRIPT_DIR:/hotspot \
  -e DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket \
  --name $container $container

nmcli connection show 
