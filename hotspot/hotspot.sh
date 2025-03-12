#!/bin/bash
#
# Create hotspot that does not expose internet
#

set -euo pipefail
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=/hotspot/.env
INTERFACE=wlan0
WIFI_CHANNEL=11

set -x
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' $ENV_FILE | xargs)
else
    echo "Missing $ENV_FILE file. Exiting..."
    exit 1
fi

nmcli radio wifi on
iw dev $INTERFACE set power_save off

nmcli connection down "$WIFI_SSID" || true

nmcli connection delete "$WIFI_SSID" 2>/dev/null || true

nmcli connection add type wifi ifname $INTERFACE mode ap ssid "$WIFI_SSID" \
    connection.id "$WIFI_SSID" \
    wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$WIFI_PASS" \
    ipv4.method shared ipv4.addresses "$WIFI_IP" \
    802-11-wireless.band bg \
    802-11-wireless.channel "$WIFI_CHANNEL"

nmcli connection show

nmcli connection up "$WIFI_SSID" || true

tail -f /dev/null