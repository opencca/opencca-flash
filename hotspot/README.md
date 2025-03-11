# opencca-hotspot

This folder captures WIFI hotspot management for opencca flashserver.

In order to flash firmware image onto board, power must be cut from board.

We use an IOT smart plug that exposes control over HTTP.


## Run
Ensure to create .env file in this directory. See .env.template.

```sh
./run_hotspot.sh
```


### Run during System Boot

See opencca-hotspot.service for systemd template to run hotspot during system boot.

```
sudo cp -rf opencca-hotspot.service /etc/systemd/system/opencca-hotspot.service
sudo systemctl daemon-reload
sudo systemctl enable opencca-hotspot
sudo systemctl start opencca-hotspot
```
