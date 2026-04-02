# Flash Firmware

This repo provides scripts to simplify flashing the OpenCCA board.  You can either reuse the scripts or follow the manual steps below.

## Manual Flashing
>[!IMPORTANT]
> The ROCK 5B uses USB-C Power Delivery (PD) for power, but **PD negotiation often happens too late**, causing **infinite reboot loops**.
> 
> We use an [Anker PowerExpand 6-in-1](https://www.amazon.de/dp/B08CKXNJZS) and a [Anker Nano II](https://www.amazon.de/dp/B094QKV6S8).  
> Detailed info and compatibility list: [Radxa ROCK 5B Power Supply Info](https://wiki.radxa.com/Rock5/rock5b/powersupply).
>
> We recommend the 16 GB Version of the [Rock 5b](https://de.aliexpress.com/item/1005007507141308.html?spm=a2g0o.order_detail.order_detail_item.3.4e1d6368VO4dVf&gatewayAdapt=glo2deu).

More information on flashing, development, and serial console in Radxa documents [Getting Started](https://wiki2.radxa.com/Rock5/5b/getting_started), [Rock 5B](https://docs.radxa.com/en/rock5/rock5b).

### Boot Media

Boot options: eMMC, microSD, NVMe. The built rootfs is set up to boot from eMMC. We used [this chip](https://de.aliexpress.com/item/1005007003959424.html?spm=a2g0o.order_list.order_list_main.35.4f2418023Ja2xZ&gatewayAdapt=glo2deu). 

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
<details>
  <summary>See contents of opencca.tar.gz </summary>
  
```
$ tree 
├── bl31.elf
├── idbloader.img
├── linux
│   ├── Image
│   ├── linux-headers-6.12.0-opencca-wip_6.12.0-opencca-wip_arm64.deb
│   ├── linux-image-6.12.0-opencca-wip_6.12.0-opencca-wip_arm64.deb
│   ├── linux-image-6.12.0-opencca-wip-dbg_6.12.0-opencca-wip_arm64.deb
│   ├── linux-libc-dev_6.12.0-opencca-wip_arm64.deb
│   └── rk3588-kernel-config
├── lkvm
├── rk3588_ddr_lp4_2112MHz_lp5_2736MHz_v1.08.bin
├── rootfs
│   └── opencca-image-rockchip-rock5b-rk3588.img
├── tf-rmm.elf
├── tools
│   ├── rk3588_spl_loader_v1.08.111.bin
│   ├── rkdeveloptool-aarch64
│   └── rkdeveloptool-x86
├── u-boot
├── u-boot.itb
├── uboot-rk3588-rock-5b.dtb
├── u-boot-rockchip.bin
└── u-boot-rockchip-spi.bin

4 directories, 20 files
```

</details>

For the next step, you will need the `opencca-image-rockchip-rock5b-rk3588.img` image file. You obtain it either by downloading a pre-built version or by building it yourself.

### Flash steps

Flash the root file system along with the firmware onto the board. The image is configured to boot from eMMC.

**Initial Flash with Root FS:**

```sh
# 1. Enter maskrom mode (press buttons)

# 2. Flash SPL loader to interact with board
# You find rk3588_spl_loader_v1 in ./tools/rk3588/
sudo rkdeveloptool db rk3588_spl_loader_v1.08.111.bin

# 3. Flash partitions
sudo rkdeveloptool wl 0 opencca-image-rockchip-rock5b-rk3588.img

# 4. Reboot
sudo rkdeveloptool rd
```

The system now reboots and boots into a Debian root file system.
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
To install a modified version of TF-A, RMM, or U-Boot, run the following steps;

```sh
# 1. Enter maskrom mode (press buttons)

# 2a: Flash SPI firmware (for use with SDcard)
sudo rkdeveloptool cs 2
sudo rkdeveloptool wl 0 u-boot-rockchip-spi.bin

# 2b. Flash eMMC firmware
sudo rkdeveloptool cs 1
sudo rkdeveloptool wl 0x40 u-boot-rockchip.bin
```
The u-boot-*.bin already bundles the BL1 and BL2 bootloaders together. You can also flash them manually.
```sh
sudo rkdeveloptool wl 0x40 idbloader.img
sudo rkdeveloptool wl 0x4000 u-boot.itb
sudo rkdeveloptool rd
```

`u-boot-*` and `idbloader.img` you obtain by [building the software stack](https://github.com/opencca/opencca-build)
or from the prebuilt release download.

**Update the Linux Kernel:**  
Updating the firmware does not flash any changes to the Linux kernel. The Linux kernel image is part of `opencca-image-rockchip-rock5b-rk3588.img` and located under `/boot/vmlinuz-6.12.0-opencca-wip` within the image. The simplest way to update the Linux kernel is to rebuilt `opencca-image-rockchip-rock5b-rk3588.img` with the build script in [opencca-build](https://github.com/opencca/opencca-build). However, this takes a lot of time.

A faster method is to directly modify an existing `opencca-image-rockchip-rock5b-rk3588.img` file (e.g. the prebuilt one). Under Linux host systems, link the `.img` file to a loop device, mount it and overwrite `boot/vmlinuz-6.12.0-opencca-wip` with `Image` in `snapshot` after rebuilding the Linux kernel:

```sh
# 1. Link with /dev/loop0
sudo losetup -Pf opencca-image-rockchip-rock5b-rk3588.img

# 2. Mount partition 3 (EFI System in image)
sudo mkdir -p /mnt/opencca_linux
sudo mount /dev/loop0p3 /mnt/opencca_linux

# 3. Overwrite kernel image (call from within snapshot folder)
sudo cp Image /mnt/opencca_linux/boot/vmlinuz-6.12.0-opencca-wip
sudo umount /mnt/opencca_linux

# 4. Enter maskrom mode (press buttons)

# 5. Flash SPL loader to interact with board
# You find rk3588_spl_loader_v1 in ./tools/rk3588/
sudo rkdeveloptool db rk3588_spl_loader_v1.08.111.bin

# 6. Flash new partitions (this takes a while)
sudo rkdeveloptool wl 0 opencca-image-rockchip-rock5b-rk3588.img
sudo rkdeveloptool rd
```

# Using Scripts
If you build an [opencca automation box](https://opencca.github.io/docs/guides/hardware/), you may use `flash.sh` to automate common tasks.
A Docker container sets up all dependencies (`./docker/`).

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

Copy `.env.template` to `.env` and configure it before use.

## Flash to eMMC

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

