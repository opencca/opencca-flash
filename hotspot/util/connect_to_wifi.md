# Connect to an existing Wifi Network

```
nmcli device wifi list
nmcli device wifi connect "MyNetwork" password "MyPassword"
```

### Persistent
```
nmcli connection add type wifi ifname wlan0 ssid "MyNetwork" \
    wifi-sec.key-mgmt wpa-psk wifi-sec.psk "MyPassword" \
    connection.autoconnect yes

nmcli connection up "MyNetwork"
nmcli connection show
```