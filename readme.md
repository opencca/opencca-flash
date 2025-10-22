# Flash Firmware

This repo provides scripts to simplify the flashing process for the OpenCCA board.  You can either reuse the scripts or follow the manual steps below.

## Manual Flashing

Based on the [Radxa Maskrom Guide](https://docs.radxa.com/en/rock5/rock5b/low-level-dev/maskrom/linux).

>[!IMPORTANT]
> The ROCK 5B uses USB-C Power Delivery (PD) for power, but **PD negotiation often happens too late**, causing **infinite reboot loops**.
> 
> We use a [Anker PowerExpand 6-in-1](https://www.amazon.de/dp/B08CKXNJZS) and a [Anker Nano II](https://www.amazon.de/dp/B094QKV6S8).  
> Detailed info and compatibility list: [Radxa ROCK 5B Power Supply Info](https://wiki.radxa.com/Rock5/rock5b/powersupply).
>
> We recommend the 16 GB Version of the [Rock 5b](https://de.aliexpress.com/item/1005007507141308.html?spm=a2g0o.order_detail.order_detail_item.3.4e1d6368VO4dVf&gatewayAdapt=glo2deu).



### Boot Media

Boot options: eMMC, microSD, NVMe. The built rootfs is set up to boot from eMMC. We used this [this chip](https://de.aliexpress.com/item/1005007003959424.html?spm=a2g0o.order_list.order_list_main.35.4f2418023Ja2xZ&gatewayAdapt=glo2deu). 

### Enter Maskrom Mode

1. Hold the Maskrom button (points upward)
2. Connect USB to host
3. Release the button

### Flashing from Release

Use either [your own build](https://github.com/opencca/opencca-build/) or a prebuilt image.

```bash
# Example (prebuilt systex25 version):
wget https://github.com/opencca/opencca-releases/releases/download/opencca/systex25/opencca.tar.gz
tar -xzf opencca.tar.gz
```
### Flash steps

Flash the rootfile system along with the firmware onto the board. The image is configured to boot from eMMC.

**Initial Flash with Root FS:**

```sh
# 1. enter maskrom mode (press buttons)

# 2. flash SPL loader to interact with board
sudo rkdeveloptool db rk3588_spl_loader_v1.08.111.bin

# 3. flash partitions
sudo rkdeveloptool wl 0 opencca-image-rockchip-rock5b-rk3588.img

# 4. Reboot
sudo rkdeveloptool rd
```

The system now reboots and boots into a debian root file system.
(Username: user, password: user).

```
Linux opencca-rock5b-rk3588 6.12.0-opencca-wip #wip SMP PREEMPT Thu Jul 31 08:44:48 UTC 2025 aarch64
  ___                    ____ ____    _    
 / _ \ _ __   ___ _ __  / ___/ ___|  / \   
| | | | '_ \ / _ \ '_ \| |  | |     / _ \  
| |_| | |_) |  __/ | | | |__| |___ / ___ \ 
 \___/| .__/ \___|_| |_|\____\____/_/   \_\
      |_|                                  
user@opencca-rock5b-rk3588:~$ 
```
Run the `run_realm_vm.sh` script located in the home directory to run a realm VM.

```
user@opencca-rock5b-rk3588:~$ ./run_realm_vm.sh
```

**Update Firmware:**  
To install a modified version of TF-A, RMM or U-Boot, run the following steps;

```sh
# 1. enter maskrom mode (press buttons)

# 2a: Flash SPI firmware (for use with SDcard)
sudo rkdeveloptool cs 2
sudo rkdeveloptool wl 0 u-boot-rockchip-spi.bin

# 2b. Flash eMMC firmware
sudo rkdeveloptool cs 1
sudo rkdeveloptool wl 0 u-boot-rockchip-spi.bin
```
The u-boot-*.bin already bundles the BL1 and BL2 bootloader togeter. You can also flash them manually.
```sh
sudo rkdeveloptool wl 0x40 idbloader.img
sudo rkdeveloptool wl 0x4000 u-boot.itb
sudo rkdeveloptool rd
```


# Using Scripts
The `flash.sh` script automates common tasks.
A docker container setups up all dependencies (`./docker/`).

```sh
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

Copy `env.template` to `.env` and configure it before use.

## FLash to eMMC

```sh
./flash.sh mmc
```
Flashes assets from the snapshot/ directory to eMMC.

## Flash to SPI

```sh
./flash.sh spi
```
Flashes assets from the snapshot/ directory to SPI.


## Open UART console
```sh
./flash.sh minicom
```

