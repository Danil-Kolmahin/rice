```sh
fdisk -l # check availlable disks

fdisk /dev/vda # "/dev/vda" is the chosen disk to be partioned into our FS

# --- inside fdisk ---
g               # partion type GPT (default)
n               # work on partion 1
<Enter>         # name (default 1)
<Enter>         # start point
+1G             # end point
t               # change partion type
1               # "EFI System"

n               # work on partion 2
<Enter>         # name (default 2)
<Enter>         # start point
<Enter>         # end point

p               # (optional) check partion, should be /dev/vda1, /dev/vda2
w               # write and exit
# --- inside fdisk ---

mkfs.fat -F32 /dev/vda1 # format EFI partion
cryptsetup luksFormat /dev/vda2 # encrypt partition
cryptsetup open /dev/vda2 main # temporaly open as "main" (reboot will close)
mkfs.ext4 /dev/mapper/main #format FS partion

mount /dev/mapper/main /mnt
mount --mkdir /dev/vda1 /mnt/boot

pacstrap -K /mnt base linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab # save partion info into system

arch-chroot /mnt

passwd

## possible to automate

pacman -S networkmanager sudo git uv
systemctl enable NetworkManager # add `--now` flag if after install

useradd -m -G wheel se
passwd se

EDITOR=nano visudo # or `nano /etc/sudoers`, enable sudo usage
# uncomment
%wheel ALL=(ALL:ALL) ALL
# uncomment

## possible to automate

nano /etc/mkinitcpio.conf
# change/add line inside (sd-encrypt needs to be added)
HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole sd-encrypt block filesystems fsck)
# change/add line inside (sd-encrypt needs to be added)

mkinitcpio -P # update/rewrite config

bootctl install # install systemd-boot

cat > /boot/loader/loader.conf << EOF
default @saved
timeout 3
console-mode max
editor no
auto-reboot yes
auto-poweroff yes
EOF

cat > /boot/loader/entries/arch.conf << EOF
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options rd.luks.name=$(blkid -s UUID -o value /dev/vda2)=main root=/dev/mapper/main rd.luks.options=password-echo=no
EOF

bootctl update # TODO: test if needed

exit

umount -R /mnt

reboot
```

#### real device
```sh
nmtui # connect to wifi, `iwctl` if `nmtui` missing 

fdisk -l # check availlable disks

fdisk /dev/nvme0n # "/dev/nvme0n" is the chosen disk to be partioned into our FS

# --- inside fdisk ---
n               # work on partion
5               # partion #5
<Enter>         # start point
+1G             # end point
t               # change partion type
1               # "EFI System"

n               # work on partion
6               # partion #6
<Enter>         # start point
<Enter>         # end point

p               # (optional) check partion, should be /dev/nvme0n5p, /dev/nvme0n6p + 1-4 from win11
w               # write and exit
# --- inside fdisk ---

mkfs.fat -F32 /dev/nvme0n5p # format EFI partion
cryptsetup luksFormat /dev/nvme0n6p # encrypt partition
cryptsetup open /dev/nvme0n6p main # temporaly open as "main" (reboot will close)
mkfs.ext4 /dev/mapper/main #format FS partion

mount /dev/mapper/main /mnt
mount --mkdir /dev/nvme0n5p /mnt/boot

pacstrap -K /mnt base linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab # save partion info into system

mount --mkdir /dev/nvme0n1p /mnt/windows-efi # mount win11 efi for copying

arch-chroot /mnt

passwd

## possible to automate

pacman -S networkmanager sudo git uv
systemctl enable NetworkManager # add `--now` flag if after install

pacman -S nvidia nvidia-utils # TODO: test if both needed, try nuvea

useradd -m -G wheel se
passwd se

EDITOR=nano visudo # or `nano /etc/sudoers`, enable sudo usage
# uncomment
%wheel ALL=(ALL:ALL) ALL
# uncomment

## possible to automate

nano /etc/mkinitcpio.conf
# change/add line inside (sd-encrypt needs to be added)
HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole sd-encrypt block filesystems fsck)
# change/add line inside (sd-encrypt needs to be added)

mkinitcpio -P # update/rewrite config

bootctl install # install systemd-boot

cat > /boot/loader/loader.conf << EOF
default @saved
timeout 3
console-mode max
editor no
auto-reboot yes
auto-poweroff yes
EOF

cat > /boot/loader/entries/arch.conf << EOF
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options rd.luks.name=$(blkid -s UUID -o value /dev/uda2)=main root=/dev/mapper/main rd.luks.options=password-echo=no
EOF

cp -r /mnt/windows-efi/EFI/Microsoft /boot/EFI # copy win11 efi to anable systemd-boot recognition
# TODO: check if not corrupted by win11 updates, find more sustainable option

bootctl update # TODO: test if needed

exit

umount -R /mnt

reboot
```