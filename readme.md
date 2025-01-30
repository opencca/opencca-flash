# Board Server RPI

```
+ set +x
Usage: ./flash.sh <command>
Commands:
  spi       - Flash via SPI
  mmc       - Flash via MMC
  clear     - Clear the SPI flash memory
  maskrom   - Put device into maskrom mode and flash memory driver.
  device    - Alias for maskrom
  on        - Power on the board
  off       - Power off the board
  reboot    - Reboot the board
  minicom   - Connect to board with ttyusb
  help      - Show this help message
```

See flash.env.inc as template, create flash.env.

## Workflow
Flash new firmware

```
./flash.sh mmc
```
- flashes assets from /assets/ onto device, we use emmc

## Get uart
```
sudo ./flash.sh minicom
```

