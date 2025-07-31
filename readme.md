# Flash Server for opencca

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

See env.template as template, create .env file.

## Flash firmware (emmc)
Flash new firmware (with emmc)

```
./flash.sh mmc
```
- Flashes assets from snapshot directory onto device.

## Flash firmware (spi)
Flash new firmware (spi nand)

```
./flash.sh spi
```
- flashes assets from snapshot directory onto device


## Get uart
```
./flash.sh minicom
```

