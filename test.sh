#!/usr/bin/env bash
# Usage: ./install.sh <step>
# Steps in order: partition | install | configure | finish
set -euo pipefail

DISK="/dev/vda"
EFI_PART="${DISK}1"
ROOT_PART="${DISK}2"
LUKS_NAME="main"

case "${1:-}" in

partition)
  echo "==> Cannot automate partitioning — run fdisk manually:"
  echo ""
  echo "  fdisk $DISK"
  echo "    g          # new GPT"
  echo "    n          # partition 1 (EFI)"
  echo "    <enter> <enter> +1G"
  echo "    t  1       # type: EFI System"
  echo "    n          # partition 2 (root)"
  echo "    <enter> <enter> <enter>"
  echo "    w          # write & exit"
  echo ""
  echo "Then run: $0 install"
  ;;

install)
  mkfs.fat -F32 "$EFI_PART"

  echo "==> LUKS passphrase (you will be prompted twice):"
  cryptsetup luksFormat "$ROOT_PART"
  cryptsetup open "$ROOT_PART" "$LUKS_NAME"
  mkfs.ext4 /dev/mapper/"$LUKS_NAME"

  mount /dev/mapper/"$LUKS_NAME" /mnt
  mount --mkdir "$EFI_PART" /mnt/boot

  pacstrap -K /mnt base linux linux-firmware
  genfstab -U /mnt >> /mnt/etc/fstab

  echo "Done. Run: $0 configure"
  ;;

configure)
  read -rp  "Username: "           USERNAME
  read -rsp "Root password: "      ROOT_PASS; echo
  read -rsp "Password for $USERNAME: " USER_PASS; echo

  arch-chroot /mnt bash -s "$USERNAME" "$ROOT_PASS" "$USER_PASS" <<'CHROOT'
    USERNAME="$1"; ROOT_PASS="$2"; USER_PASS="$3"

    echo "root:${ROOT_PASS}" | chpasswd

    pacman -S --noconfirm networkmanager sudo git uv
    systemctl enable NetworkManager

    useradd -m -G wheel "$USERNAME"
    echo "${USERNAME}:${USER_PASS}" | chpasswd
    sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

    sed -i 's/^HOOKS=.*/HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole sd-encrypt block filesystems fsck)/' /etc/mkinitcpio.conf
    mkinitcpio -P
CHROOT

  ROOT_UUID=$(blkid -s UUID -o value "$ROOT_PART")
  arch-chroot /mnt bootctl install

  cat > /mnt/boot/loader/loader.conf <<'EOF'
default arch
timeout 3
console-mode max
editor no
EOF

  cat > /mnt/boot/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options rd.luks.name=${ROOT_UUID}=${LUKS_NAME} root=/dev/mapper/${LUKS_NAME} rd.luks.options=password-echo=no rw
EOF

  echo "Done. Run: $0 finish"
  ;;

finish)
  umount -R /mnt
  echo "All done. Remove install medium and reboot."
  ;;

*)
  echo "Usage: $0 <step>"
  echo "Steps in order: partition | install | configure | finish"
  ;;

esac