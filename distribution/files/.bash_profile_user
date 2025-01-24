#
# ~/.bash_profile
#

# Shell config
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=
export EDITOR=nano

DESKTOP=y

# Session Launcher
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]] && [[ "$DESKTOP" == "y" ]]; then
	dbus-run-session -- labwc
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
