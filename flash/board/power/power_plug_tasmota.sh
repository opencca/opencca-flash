#!/usr/bin/env bash
set -euo pipefail

#
# Script to interact with a tasmota based IOT smart plug
# https://tasmota.github.io/docs/
#
# Change endpoint accordingly if you dont use tasmota firmware
#

OPENCCA_PLUG_URL="${OPENCCA_PLUG_URL:-}"

function do_request() {
    local url="$1"
    local response
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    echo "Request: $url"

    if [[ "$response" -ne 200 ]]; then
        echo "Error: Failed to connect to $url. Status code=$response"
        exit 1
    fi

    echo "Success: $url"
}

function power_control() {
    do_request "${OPENCCA_PLUG_URL}?cmnd=POWER+$1"
}

set +u
case "$1" in
    on|off|toggle) power_control "${1^^}" ;;  # ^^: Convert to uppercase (ON, OFF, TOGGLE)
    *) echo "Usage: $0 {on|toggle|off}"
esac