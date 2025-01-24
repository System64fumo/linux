#!/bin/sh

# Hostname
# TODO: This should be set up by the GUI not here
echo "system" > /etc/hostname &

# Resolver
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

# Debloat
echo "Debloating.."
pacman -Rns --noconfirm \
xfsprogs reiserfsprogs wpa_supplicant-dinit openssh-dinit ntp-dinit ntp \
linux-aarch64-lts-headers linux-aarch64-lts linux-aarch64-headers \
linux-aarch64 haveged-dinit haveged f2fs-tools dhcpcd-dinit sudo &> /tmp/pacman.log
userdel -rf armtix

# Setup pacman
sed -i 's|#CacheDir    = /var/cache/pacman/pkg/|CacheDir     = /tmp/pacman|g' /etc/pacman.conf
sed -i 's/HoldPkgc/#HoldPkgc/g' /etc/pacman.conf
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads/ParallelDownloads/g' /etc/pacman.conf

mkdir -m 777 /tmp/cache /opt/setup

pacman-key --init >> /tmp/pacman.log
pacman-key --populate >> /tmp/pacman.log
pacman -Syu --noconfirm --disable-download-timeout artix-archlinux-support >> /tmp/pacman.log

# Fix arch trust issues (https://archlinuxarm.org/forum/viewtopic.php?t=16769)
echo "Fixing pacman keys.."
pacman-key --finger 68B3537F39A313B3E574D06777193F152BDBE6A6 2>/dev/null | grep marginal >/dev/null 2>&1 \
&& pacman-key --lsign-key 68B3537F39A313B3E574D06777193F152BDBE6A6 >/dev/null 2>&1 \
|| true
pacman-key --populate archlinuxarm >> /tmp/pacman.log

# Configure arch repos
sed -i '/^#\[\(extra\)\]/s/^#//' /etc/pacman.conf
sed -i '/^#\[\(community\)\]/s/^#//' /etc/pacman.conf
sed -i '/^#\[\(alarm\)\]/s/^#//' /etc/pacman.conf
sed -i '/^#\[\(aur\)\]/s/^#//' /etc/pacman.conf
sed -i '/^#\(Include\)/s/^#//' /etc/pacman.conf

# Install stuff
echo "Installing and updating packages.."
pacman -Syu --noconfirm --disable-download-timeout base-devel opendoas busybox pipewire{,-pulse,-alsa,-jack} \
wireplumber labwc swaybg foot nemo ttf-{liberation,dejavu,font-awesome} otf-ipafont \
polkit-gnome gnome-keyring git xdg-user-dirs firefox geany htop networkmanager blueman \
pavucontrol mpv cage rtkit sassc dropbear >> /tmp/pacman.log

pacman -Rn --noconfirm base-devel sudo >> /tmp/pacman.log

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

# Setup doas
echo "permit nopass :wheel" > /etc/doas.conf

# Create setup account
useradd -m setup \
-G wheel,video,audio,input,disk,storage \
-u 1001

# Install yay
su setup -c "
git clone --single-branch --depth 1 https://aur.archlinux.org/yay-bin /tmp/yay-bin
cd /tmp/yay-bin
makepkg -si --noconfirm"

# Configure yay
su setup -c "yay --save --editor nano --noanswerclean --noanswerdiff --noanswerupgrade --cleanafter --removemake"

# Install AUR packages
su setup -c "echo y | yay -S --noconfirm --disable-download-timeout sys{menu,hud,bar,board,power,lock,shell} frogfm mathfairy-git"

# Replace init system
chmod -R 777 /opt/setup/packages
rm /usr/bin/init
su setup -c "
cd /opt/setup/packages/sysvinit
(echo y;echo y;echo y;echo y;echo y) | makepkg -si"
ln -s /usr/bin/busybox /usr/bin/fbsplash

# Setup auto login for setup
sed -i "s/root/setup/g" /etc/inittab

# Install GUI stuff
su setup -c "
git clone --single-branch --depth 1 https://www.github.com/system64fumo/sysinstall /tmp/sysinstall
cd /tmp/sysinstall
make -j8
doas mv ./build/sysinstall /opt/setup"

su setup -c "
git clone --single-branch --depth 1 https://github.com/vinceliuice/Colloid-gtk-theme /tmp/gtk-theme
cd /tmp/gtk-theme
./install.sh -c dark -c light -s standard -t grey --tweaks normal --tweaks black
doas mv ~/.themes/* /usr/share/themes/"

su setup -c "
git clone --single-branch --depth 1 https://github.com/vinceliuice/Colloid-icon-theme /tmp/icon-theme
cd /tmp/icon-theme
./install.sh -s default -t grey
cd ./cursors
./install.sh
doas mv ~/.local/share/icons/* /usr/share/icons/"

# Move files
mv /opt/setup/.bash_profile_setup /home/setup/.bash_profile
chown -R setup:setup /home/setup

# Cleanup
pacman -Rns --noconfirm sassc >> /tmp/pacman.log
rm -rf /tmp/*
rm -rf /home/setup/.cache
rm -rf /opt/setup/packages
rm -rf /run/{dinit.d,sudo}
pkill -9 gpg-agent
