#!/usr/bin/env bash
set -euo pipefail

# curl -s https://raw.githubusercontent.com/Danil-Kolmahin/rice/main/test.sh | bash

USERNAME=$(whiptail --inputbox "Username:" 8 40 3>&1 1>&2 2>&3)
ROOT_PASS=$(whiptail --passwordbox "Root password:" 8 40 3>&1 1>&2 2>&3)
USER_PASS=$(whiptail --passwordbox "Password for $USERNAME:" 8 40 3>&1 1>&2 2>&3)
DISK=$(whiptail --inputbox "Target disk:" 8 40 "/dev/vda" 3>&1 1>&2 2>&3)
EFI_PART="${DISK}1"
ROOT_PART="${DISK}2"
LUKS_NAME="main"
LUKS_PASS=$(whiptail --passwordbox "Disk encryption passphrase:" 8 40 3>&1 1>&2 2>&3)
whiptail --yesno "WARNING: This will destroy all data on $DISK. Continue?" 8 50 || exit 1

echo "Partitioning..."
sfdisk "$DISK" <<EOF
label: gpt
size=1G, type=uefi
type=linux
EOF

mkfs.fat -F32 "$EFI_PART"

echo "Setting up disk encryption..."
echo "$LUKS_PASS" | cryptsetup luksFormat --batch-mode "$ROOT_PART"
echo "$LUKS_PASS" | cryptsetup open "$ROOT_PART" "$LUKS_NAME"
mkfs.ext4 /dev/mapper/"$LUKS_NAME"

mount /dev/mapper/"$LUKS_NAME" /mnt
mount --mkdir "$EFI_PART" /mnt/boot

echo "Installing base system..."
pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

echo "Configuring initial system configurations..."
arch-chroot /mnt bash -s "$USERNAME" "$ROOT_PASS" "$USER_PASS" <<'CHROOT'
  USERNAME="$1"; ROOT_PASS="$2"; USER_PASS="$3"

  echo "root:${ROOT_PASS}" | chpasswd

  pacman -S --noconfirm networkmanager sudo git uv
  systemctl enable NetworkManager

  useradd -m -G wheel "$USERNAME"
  echo "${USERNAME}:${USER_PASS}" | chpasswd
  sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

  sed -i 's/^HOOKS=.*/HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole sd-encrypt block filesystems fsck)/' /etc/mkinitcpio.conf
  mkinitcpio -P || true
CHROOT

ROOT_UUID=$(blkid -s UUID -o value "$ROOT_PART")
arch-chroot /mnt bootctl install

cat > /mnt/boot/loader/loader.conf <<'EOF'
default @saved
timeout 0
console-mode max
editor no
auto-reboot yes
auto-poweroff yes
EOF

cat > /mnt/boot/loader/entries/arch.conf <<EOF
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options rd.luks.name=${ROOT_UUID}=${LUKS_NAME} root=/dev/mapper/${LUKS_NAME} rd.luks.options=password-echo=no
EOF

git clone https://github.com/Danil-Kolmahin/rice.git /mnt/home/"$USERNAME"/projects/rice
arch-chroot /mnt chown -R "$USERNAME:$USERNAME" /home/"$USERNAME"/projects

umount -R /mnt

read -rp "Done. You can safely remove install medium. Reboot now? (Y/n): " reboot_ans
[[ "${reboot_ans:-Y}" =~ ^[Yy]$ ]] && reboot
