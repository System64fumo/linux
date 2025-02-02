#!/bin/sh

export LANGUAGE="$1"
export TIMEZONE="$2"
export FULLUSER="$3"
export USERNAME="$4"
export PASSWORD="$5"

echo "Setting language"
doas sed -i "s/#$LANGUAGE/$LANGUAGE/g" /etc/locale.gen
echo "LANG=$LANGUAGE.UTF-8" doas tee | /etc/locale.conf
locale-gen &> /dev/null &

echo "Setting timezone"
doas ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime
doas pkill time
doas /etc/rc.d/service start time & disown

echo "Creating user"
doas useradd -m\
 "$USERNAME"\
 -G wheel,video,audio,disk,storage,network\
 -p $(perl -e "print crypt($PASSWORD,aa)")\
 -u 1000

doas su "$USERNAME" -c "xdg-user-dirs-update" &

doas chfn -f "$FULLUSER" "$USERNAME" &> /dev/null &
doas chmod +x /home/"$USERNAME"/.config/scripts/start-session.sh &

echo "Setting up autologin"
doas sed -i "s/setup/$USERNAME/g" /etc/inittab
doas mv /opt/setup/.bash_profile_user /home/"$USERNAME"/.bash_profile
doas chown "$USERNAME":"$USERNAME" -R /home/"$USERNAME"
doas pkill -1 init

wait
echo "Done!"
doas rm -rf /tmp/.X11-unix
doas rm -rf /run/user/1000/*
doas su -c "echo 'permit nopass :root' > /etc/doas.conf;echo 'permit persist :wheel' >> /etc/doas.conf;pkill -x login"
