## Requirements

* **Firmware:** UEFI only

## Installation

### 1. Get Arch Linux ISO

Download the latest official image from the [Arch Linux Download Page](https://archlinux.org/download).

### 2. Burn ISO to installation media

Identify your target flash drive using `lsblk` then write the ISO:

```bash
# Ensure target partition is unmounted before writing
sudo cp ~/downloads/archlinux.iso /dev/sdX && sync
```
*(Windows users can utilize [Rufus](https://rufus.ie) configured for UEFI/GPT/FAT32 in DD Image mode).*

### 3. Boot and establish internet connection

Boot into the official Arch Linux live environment. If a wired connection is unavailable, connect to Wi-Fi using the following commands:

```bash
iwctl device list # 3.1. List your wireless device name (usually wlan0)
iwctl station $DEVICE scan # 3.2. Scan for available networks
iwctl station $DEVICE get-networks # 3.3. List the discovered networks
iwctl --passphrase=$PASSPHRASE station $DEVICE connect $SSID # 3.4. Connect to your network
```

### 4. Execute installation

Run the automated setup script:

```bash
curl -s https://raw.githubusercontent.com/danil-kolmahin/rice/main/apply | bash
```
