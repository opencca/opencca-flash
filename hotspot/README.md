# opencca-hotspot

This module creates a Wi-Fi hotspot to communicate with a smart
power plug over HTTP. It is used in the opencca development workflow to
power-cycle the board during firmware flashing.

> **Note:** If your smart plug is already reachable via an existing
> Wi-Fi access point, this module is **not needed**.


## Getting Started

### 1. Configure Environment

Copy and edit the environment file:

```bash
cp ./.env.template .env
emacs .env
```

### 2. Install as Systemd Service
Install and enable the service to run at system startup:

```bash
sudo make install
```

See Makefile for more information

## Troubleshooting

### Connecitivity Issues (Raspberry Pi)
If the hotspot drops or becomes unstable, disable Wi-Fi power saving:

```
echo "options cfg80211 ieee80211_default_ps=0" | sudo tee /etc/modprobe.d/disable_wifi_powersave.conf
```

