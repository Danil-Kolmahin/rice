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

### 3. Boot and execute
Boot into the official Arch Linux live environment, and run:
<!-- TODO: add "Ensure you have an active internet connection" line for not-from-backup provision -->

```bash
curl -sL https://raw.githubusercontent.com/Danil-Kolmahin/rice/main/apply | bash
```
