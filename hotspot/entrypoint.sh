#!/bin/bash
#
# Create hotspot that does not expose internet
#

set -euo pipefail
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -x

if [ -f "/config/.env" ]; then
    export $(grep -v '^#' /config/.env | xargs)
else
    echo "Missing /config/.env file. Exiting..."
    exit 1
fi

nmcli connection delete "$WIFI_SSID" 2>/dev/null || true

nmcli connection add type wifi ifname wlan0 mode ap ssid "$WIFI_SSID" \
    connection.id "$WIFI_SSID" \
    wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$WIFI_PASS" \
    ipv4.method shared ipv4.addresses "$WIFI_IP"

nmcli connection show

nmcli connection up "$WIFI_SSID"

tail -f /dev/null