#!/bin/sh

# Audio server
/etc/rc.d/service start audio

export ADW_DISABLE_PORTAL=1
export GSK_RENDERER=cairo

export PAN_MESA_DEBUG=gl3,forcepack,crc,msaa16
export PAN_I_WANT_A_BROKEN_VULKAN_DRIVER=1
export MESA_DEBUG=silent
export mesa_glthread=true
export vblank_mode=0

export MOZ_ENABLE_WAYLAND=1
export MOZ_USE_XINPUT2=1
export MOZ_DISABLE_RDD_SANDBOX=1

export QT_QPA_PLATFORMTHEME=qt6ct

export ELECTRON_OZONE_PLATFORM_HINT=wayland

dbus-run-session -- labwc &> /tmp/log/session.log
