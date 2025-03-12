# RK3588 Flash Management

## Files
```
# Entry Point
./board.sh.............: Entry point to control maskrom mode

# Power
./power.sh.............: Entry point to drive power management
./power_tasmota.sh.....: HTTP endpoint for tasmota based smart plug
./power_usb............: USB port power control

# GPIO Circuit Control
./maskrom.sh...........: Entry point to control board button
./gpio-maskrom.py......: GPIO control

# Install
./install.sh...........: Install dependencies
```

## Install
```
./install.sh
```

## Usage
```
./board.sh {on|off|reboot|maskrom}
```

## Configuration

### Power Smart Plug 

We use tasmota based smart plug (see ./power_tasmota.sh). 

https://tasmota.github.io/docs/

If your smart plug uses a different firmware, create new endpoint wrapper accordingly.

Functionality is implemented in simple bash scripts.

```
./power_tasmota.sh {on|toggle|off}"
```

```
# in .env file:
export POWER_PLUG_HOST="http://192.168.100.11/cm"
```

### USB Port

We use uhubctl to change power state of USB port.

```
./power_usb.sh {on|toggle|off}"
```

Select the usb port that the rk3588 is connected to as follows:

```
root@opencca_docker /o/f/board# sudo uhubctl 

Current status for hub 4-1 [2109:0817 VIA Labs, Inc. USB3.0 Hub 000000000, USB 3.20, 4 ports, ppps]
  Port 1: 02a0 power 5gbps Rx.Detect
  Port 2: 02a0 power 5gbps Rx.Detect
  Port 3: 0223 power 5gbps U1 enable connect [0b95:1790 ASIX AX88179A 0057831B]
  Port 4: 02a0 power 5gbps Rx.Detect
Current status for hub 4 [1d6b:0003 Linux 6.6.51+rpt-rpi-2712 xhci-hcd xHCI Host Controller xhci-hcd.1, USB 3.00, 1 ports, ppps]
  Port 1: 0203 power 5gbps U0 enable connect [2109:0817 VIA Labs, Inc. USB3.0 Hub 000000000, USB 3.20, 4 ports, ppps]
Current status for hub 3-1 [2109:2817 VIA Labs, Inc. USB2.0 Hub 000000000, USB 2.10, 5 ports, ppps]
  Port 1: 0100 power
  Port 2: 0100 power
  Port 3: 0100 power
  Port 4: 0100 power
  Port 5: 0503 power highspeed enable connect [291a:8365 Anker Anker USB-C Hub Device 0000000000000001]
Current status for hub 3 [1d6b:0002 Linux 6.6.51+rpt-rpi-2712 xhci-hcd xHCI Host Controller xhci-hcd.1, USB 2.00, 2 ports, ppps]
  Port 1: 0503 power highspeed enable connect [2109:2817 VIA Labs, Inc. USB2.0 Hub 000000000, USB 2.10, 5 ports, ppps]
  Port 2: 0103 power enable connect [0403:6001 FTDI FT232R USB UART ABSCF8M3]
Current status for hub 2 [1d6b:0003 Linux 6.6.51+rpt-rpi-2712 xhci-hcd xHCI Host Controller xhci-hcd.0, USB 3.00, 1 ports, ppps]
  Port 1: 02a0 power 5gbps Rx.Detect
Current status for hub 1 [1d6b:0002 Linux 6.6.51+rpt-rpi-2712 xhci-hcd xHCI Host Controller xhci-hcd.0, USB 2.00, 2 ports, ppps]
  Port 1: 0100 power
  Port 2: 0100 power

```

The rk3588 is connected through an Anker USB-C Hub Device.

```
Port 5: 0503 power highspeed enable connect [291a:8365 Anker Anker USB-C Hub Device 0000000000000001]
```

and uses hub 3-1 and port 5.

```
# in .env file:
export UHUBCTL_DEVICE="3-1"
export UHUBCTL_PORT="5"
```

### GPIO Maskrom

For maskrom button bypass, we use a circuit board that is driven through GPIO on flash server.


```
# Enter maskrom mode
./maskrom.sh
```


Select the GPIO pin used.

```
# in .env file:
export MOSFET_PIN=11
```

