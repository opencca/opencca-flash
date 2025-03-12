# opencca-hotspot

This folder captures WIFI hotspot management for opencca flashserver.

In order to flash firmware image onto board, power must be cut from board.

We use an IOT smart plug that exposes control over HTTP.


## Build and Run
```
sudo make install
```

## Troubleshooting

### Connecitivity Issues
```
echo "options cfg80211 ieee80211_default_ps=0" | sudo tee /etc/modprobe.d/disable_wifi_powersave.conf
```

