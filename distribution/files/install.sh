#!/bin/sh

LANGUAGE="$1"
TIMEZONE="$2"
FULLUSER="$3"
USERNAME="$4"
PASSWORD="$5"

echo "Setting language"
doas sed -i "s/#$LANGUAGE/$LANGUAGE/g" /etc/locale.gen
echo "LANG=$LANGUAGE.UTF-8" doas tee | /etc/locale.conf
locale-gen &

echo "Setting timezone"
doas ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime

echo "Creating user"
doas useradd -m\
 "$USERNAME"\
 -G wheel,video,audio,disk,storage,network\
 -p $(perl -e "print crypt($PASSWORD,aa)")\
 -u 1000

doas su "$USERNAME" -c "xdg-user-dirs-update" &

doas chfn -f "$FULLUSER" "$USERNAME" &

echo "Moving files"
doas mv /opt/setup/.config/* /home/$USERNAME/.config/
doas mv /home/setup/.config/* /home/$USERNAME/.config/
doas chown $USERNAME:$USERNAME -R /home/$USERNAME

echo "Setting theme"
doas su "$USERNAME" -c "gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'"
doas su "$USERNAME" -c "gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Grey-Dark'"
doas su "$USERNAME" -c "gsettings set org.gnome.desktop.interface icon-theme 'Colloid-Grey-Dark'"
doas su "$USERNAME" -c "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"

echo "Setting up autologin"
doas sed -i "s/setup/$USERNAME/g" /etc/inittab
doas mv /opt/setup/.bash_profile_user /home/$USERNAME/.bash_profile
doas pkill -1 init

wait
echo "Done!"
doas rm -rf /tmp/.X11-unix
doas rm -rf /run/user/1000/*
doas su -c "echo 'permit nopass :root' > /etc/doas.conf;echo 'permit persist :wheel' > /etc/doas.conf;pkill -x login"
