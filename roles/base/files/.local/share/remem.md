# list commands
# all commands
printf '%s\n' ${(ok)commands}
# all builtin commands
printf '%s\n' ${(ok)builtins}
# all aliases
printf '%s\n' ${(ok)aliases}
# get aliased value for "l"
echo $aliases[l]
# get aliased path for "git"
echo $commands[git]

# search for comunity cheatsheets
curl cheat.sh

# clear clipboard history
cliphist wipe

# calendar
cal -my

# calculator
bc -ql

# clear duplicates from command-line history
# TODO

# convert curl to hurl
echo "curl google.com" | hurlfmt --in curl

# pass: gpg key generation
gpg --gen-key
# Real name:
# Email address:
# Change (N)ame, (E)mail, or (O)kay/(Q)uit?
# We need to generate a lot of random bytes. It is a good idea to perform
# some other action (type on the keyboard, move the mouse, utilize the
# disks) during the prime generation; this gives the random number
# generator a better chance to gain enough entropy.
# gpg: revocation certificate stored as '/home/$HOME/.gnupg/openpgp-revocs.d/$ID.rev'
gpg --edit-key $ID
> expire
# Key is valid for? (0)
# Is this correct? (y/N)
> save

# pass
pass init $ID
# mkdir: created directory '/home/$HOME/.password-store/'
# git config --global init.defaultBranch main
pass git init
(cd /home/$HOME/.password-store/ && git config user.email "you@example.com")
(cd /home/$HOME/.password-store/ && git config user.name "Your Name")
pass git init

# get all upper level node_modules
find . -type d -name node_modules -prune

# archiving with tar and gzip
tar -I 'gzip -9' -cf backup.tar.gz etc
# archiving with tar only
tar -cf backup.tar etc
# extract any tar archive (result would be etc directory)
tar -xf backup.tar.gz
# view archive content (without changes, like ls -la)
tar -tvf backup.tar.gz

# qemu/kvm archlinux VM - UEFI (secure boot off)
virt-install \
  --name mirror \
  --osinfo archlinux \
  --cdrom $HOME/downloads/archlinux-x86_64.iso \
  --disk size=50 \
  --memory 4096 \
  --vcpus 1 \
  --graphics spice \
  --machine q35 \
  --boot firmware=efi,firmware.feature0.enabled=no,firmware.feature0.name=secure-boot \
  --noautoconsole

nohup virt-viewer mirror &

# qemu/kvm windows 10 VM - UEFI (secure boot off)
virt-install \
  --name win10 \
  --osinfo win10 \
  --cdrom $HOME/downloads/Win10_22H2_English_x64v1.iso \
  --disk size=80 \
  --memory 16384 \
  --vcpus 8,sockets=1,cores=4,threads=2 \
  --graphics spice \
  --machine q35 \
  --boot firmware=efi,firmware.feature0.enabled=no,firmware.feature0.name=secure-boot

https://github.com/virtio-win/kvm-guest-drivers-windows # install inside vm

# vm management
virsh list --all
virsh start mirror
virt-viewer mirror
virsh console mirror
virsh destroy mirror
virsh undefine mirror --remove-all-storage --nvram

# eject the media (removes the link to the ISO file (for Windows VM))
virsh domblklist mirror
virsh change-media mirror sdb --eject --live --config

# vm attach shared directory
## on host (vm needs to be started after this, or restarted):
mkdir ~/mirror
virsh attach-device mirror --config --file /dev/stdin <<EOF
<filesystem type='mount' accessmode='mapped'>
  <source dir='$HOME/mirror'/>
  <target dir='mirror'/>
</filesystem>
EOF

### remove
virsh detach-device mirror --config --file /dev/stdin <<EOF
<filesystem type='mount' accessmode='mapped'>
  <source dir='$HOME/mirror'/>
  <target dir='mirror'/>
</filesystem>
EOF
rm -rf ~/mirror

## on vm
sudo mkdir -p /mnt/mirror
echo 'mirror /mnt/mirror 9p trans=virtio,version=9p2000.L 0 0' | sudo tee -a /etc/fstab
sudo mount -a
### remove
sudo umount /mnt/mirror
sudo sed -i '/mirror.*\/mnt\/mirror.*9p/d' /etc/fstab
rm -rf /mnt/mirror

# check my ip
curl https://ipinfo.io
curl https://ipinfo.io | jq
curl https://ipinfo.io/ip

# mount external drive
lsblk
sudo mount --mkdir /dev/sda1 /mnt/portable-drive-0
sync
sudo umount /mnt/portable-drive-0

# record audio
pw-record record.mp3
pw-play record.mp3

# mpv
# mpv show image
mpv img.png --keep-open
# mpv show image in fullscreen
mpv img.png --fs --keep-open

# display desktop notification
notify-send "VLC" "Video playback is finished" -i vlc

# dual boot - boot into windows
systemctl reboot --boot-loader-entry=auto-windows

# generate random values
openssl rand -hex 16
openssl rand -hex 12
base64 /dev/random | head -c 2M > ~/file.txt

# generate QR code
qrencode --type ansiutf8 --level H "Text message"
qrencode --type ansiutf8 --level H "https://example.com"
qrencode --type ansiutf8 --level H "mailto:$(pass me/email | awk '/^email/{print $2}')?subject=Title&body=Text/HTML content."
qrencode --type ansiutf8 --level H "tel:$(pass me/phone | head -n1)"
qrencode --type ansiutf8 --level H "smsto:$(pass me/phone | head -n1),Content of SMS message."
qrencode --type ansiutf8 --level H "geo:51.509865,-0.118092"
qrencode --type ansiutf8 --level H "WIFI:T:$(pass me/wifi | awk '/^security/{print $2}');S:$(pass me/wifi | awk '/^name5/{print $2}');P:$(pass me/wifi | head -n1);;"
qrencode --type ansiutf8 --level H "BEGIN:VCARD
VERSION:2.1
N:$(pass me | awk 'NR==1{print $1; exit}')
FN:$(pass me | head -n1)
TEL;TYPE=voice,cell,pref:$(pass me/phone | head -n1)
TITLE:$(pass me | awk '/^title/{print $2}')
ORG:$(pass me | awk '/^organization/{print $2}')
EMAIL:$(pass me/email | awk '/^email/{print $2}')
URL:$(pass me | awk '/^url/{print $2}')
END:VCARD"
qrencode --type ansiutf8 --level H "BEGIN:VEVENT
SUMMARY:Title
DESCRIPTION:Meeting objective, agenda, homework, DoD
LOCATION:MiroTalk
DTSTART:20250617T160000
DTEND:20250617T174500
END:VEVENT"

# OpenVPN
sudo curl -s -m 600 -o "/etc/openvpn/client/$VPN_CONNECTION_NAME.ovpn" "$VPN_CONFIG_URL"
sudo nmcli connection import type openvpn file "/etc/openvpn/client/$VPN_CONNECTION_NAME.ovpn"
nmcli connection modify "$VPN_CONNECTION_NAME" +vpn.data "username=$VPN_USERNAME"
nmcli connection modify "$VPN_CONNECTION_NAME" +vpn.data "password-flags=0"
nmcli connection modify "$VPN_CONNECTION_NAME" +vpn.secrets "password=$VPN_PASSWORD"
sudo nmcli connection reload
