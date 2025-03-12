#!/usr/bin/env bash
set -euo pipefail
set -x
readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

#
# Script to interact with a tasmota based IOT smart plug
# https://tasmota.github.io/docs/
#
# Change endpoint accordingly if you dont use tasmota firmware
#
POWER_PLUG_HOST="${POWER_PLUG_HOST:-}"

function do_request() {
  local url="$1"
  local response

  response=$(curl -s -o /dev/null -w "%{http_code}" "$url")

  if [[ "$response" -ne 200 ]]; then
    echo "Error: Failed to connect to $url. status code=$response"
    exit 1
  fi

  echo "Success: $url"
}

function power_on() {
  local url_power_on="${POWER_PLUG_HOST}?cmnd=POWER+ON"
  do_request "$url_power_on"
}


function power_toggle() {
  local url_power_toggle="${POWER_PLUG_HOST}?cmnd=POWER+TOGGLE"
  do_request "$url_power_toggle"
}

function power_off() {
  local url_power_off="${POWER_PLUG_HOST}?cmnd=POWER+OFF"
  do_request "$url_power_off"
}

set +u
if [[ "$1" == "on" ]]; then
  power_on
elif [[ "$1" == "toggle" ]]; then
  power_toggle
elif [[ "$1" == "off" ]]; then
  power_off
else
  echo "Usage: $0 {on|toggle|off}"
  exit 1
fi
