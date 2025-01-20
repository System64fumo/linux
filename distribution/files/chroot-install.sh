#!/bin/sh

# TODO: Replace this with a GUI setup screen in stage 2
UNAME="default"
PASSWD="defaultpw"
HNAME="system"
HLANG="en_US"
HTIME="America/New_York"

# Hostname
echo $HNAME > /etc/hostname &

# Resolver
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

# Debloat
pacman -Rns --noconfirm xfsprogs reiserfsprogs wpa_supplicant-dinit openssh-dinit ntp-dinit ntp linux-aarch64-lts-headers linux-aarch64-lts linux-aarch64-headers linux-aarch64 haveged-dinit haveged f2fs-tools dhcpcd-dinit sudo
userdel -rf armtix

# Setup pacman
sed -i 's|#CacheDir    = /var/cache/pacman/pkg/|CacheDir     = /tmp/pacman|g' /etc/pacman.conf
sed -i 's/HoldPkgc/#HoldPkgc/g' /etc/pacman.conf
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads/ParallelDownloads/g' /etc/pacman.conf

mkdir -m 777 /tmp/cache

pacman-key --init
pacman-key --populate
pacman -Syu --noconfirm artix-archlinux-support

# Fix arch trust issues (https://archlinuxarm.org/forum/viewtopic.php?t=16769)
pacman-key --finger 68B3537F39A313B3E574D06777193F152BDBE6A6 2>/dev/null | grep marginal >/dev/null 2>&1 \
&& echo 'Fixing trust of Arch Linux ARM Build System <builder@archlinuxarm.org> key' \
&& pacman-key --lsign-key 68B3537F39A313B3E574D06777193F152BDBE6A6 >/dev/null 2>&1 \
|| true
pacman-key --populate archlinuxarm

# Configure arch repos
sed -i '/^#\[\(extra\)\]/s/^#//' /etc/pacman.conf
sed -i '/^#\[\(community\)\]/s/^#//' /etc/pacman.conf
sed -i '/^#\[\(alarm\)\]/s/^#//' /etc/pacman.conf
sed -i '/^#\[\(aur\)\]/s/^#//' /etc/pacman.conf
sed -i '/^#\(Include\)/s/^#//' /etc/pacman.conf

# Install stuff
pacman -Syu --noconfirm base-devel opendoas busybox pipewire{,-pulse,-alsa,-jack} \
wireplumber labwc swaybg foot nemo ttf-{liberation,dejavu,font-awesome} otf-ipafont \
polkit-gnome gnome-keyring git xdg-user-dirs firefox geany htop networkmanager blueman \
pavucontrol mpv cage
pacman -Rn --noconfirm base-devel sudo
pacman -U --noconfirm /packages/*
rm -rf /packages

# Configure makepkg
sed -i 's/-qg/-sqg/g' /etc/makepkg.conf
# TODO: Add appropiate CPU optimizations (Result from gcc)
# TODO: Assuming the machine has 8 cores is better than assuming it has 2, or 1,
# But guessing is not cool, Add a variable to change this later.
sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j8"/g' /etc/makepkg.conf
sed -i 's/strip docs/strip !docs/g' /etc/makepkg.conf
sed -i 's/#BUILDDIR=\/tmp\/makepkg/BUILDDIR=\/tmp\/cache\/makepkg/g' /etc/makepkg.conf
sed -i 's/-q /-q --threads=0 /g' /etc/makepkg.conf
sed -i 's/xz -c -z/xz -c -z --threads=0 /g' /etc/makepkg.conf
sed -i 's/.pkg.tar.xz/.pkg.tar/g' /etc/makepkg.conf
sed -i 's/#PACMAN_AUTH=()/PACMAN_AUTH=(doas)/g' /etc/makepkg.conf &

# Set up locale
sed -i "s/#$HLANG/$HLANG/g" /etc/locale.gen
echo "LANG=$HLANG.UTF-8" > /etc/locale.conf
locale-gen &
ln -s /usr/share/zoneinfo/$HTIME /etc/localtime &

# Set up sshd
ssh-keygen -A &

# Setup doas (For installation)
echo "permit nopass :wheel" > /etc/doas.conf

# Setup doas (For general use)
# TODO: This should be ran post GUI setup
#echo "permit nopass :root
#permit persist :wheel" > /etc/doas.conf

# Create default account
# TODO: This account should only be used for initial setup and should be deleted afterwards
# For now it can be used to test the setup
useradd -m $UNAME \
-G wheel,video,audio,input,disk,storage \
-p $(perl -e "print crypt($PASSWD,aa)") \
-u 1001

# Install yay
su "$UNAME" -c "cd /tmp;git clone https://aur.archlinux.org/yay-bin.git;cd yay-bin;makepkg -si --noconfirm"

# Configure yay
su "$UNAME" -c "yay --save --editor nano --answerdiff no --answerclean no --cleanafter --removemake"

# Install AUR packages
su "$UNAME" -c "yay -S --noconfirm sys{menu,hud,bar,power,lock,shell} frogfm mathfairy-git"

#TODO: Colloid theme needs to be configured (to not include the additional styles or colors)
#su "$UNAME" -c "yay -S --noconfirm colloid-{gtk-theme,cursors,icon-theme}-git"

# Configure user
# TODO: This should run post GUI setup
su "$UNAME" -c "gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close';gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark';gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"

# Replace init system
chmod -R 777 /files/packages
rm /usr/bin/init
su "$UNAME" -c "cd /files/packages/sysvinit;(echo y;echo y;echo y;echo y;echo y) | makepkg -si"
ln -s /usr/bin/busybox /usr/bin/fbsplash

# Setup auto login for setup
sed -i "s/root/$UNAME/g" /etc/inittab

# TODO: Remember to use kill -HUP 1 init to reload /etc/inittab post GUI setup

# Move files
mv /files/.config/* /home/$UNAME/.config/
mv /files/.bash_profile /home/$UNAME/.bash_profile
chown -R $UNAME:$UNAME /home/$UNAME

# Cleanup
rm -rf /tmp/*
rm -rf /home/$UNAME/.cache
rm -rf /files
rm -rf /run/{dinit.d,sudo}
pkill -9 gpg-agent
