#!/bin/sh

# Change this if you're using a distributed compiler
CORES=$(nproc)

# Load device profile
if [ ! -f ./device_profile ]; then
	echo "Device profile file is missing"
	echo "Generating a new one..."
	echo "Please edit '$(pwd)/device_profile'"

	# Generate a new profile
	echo "DEVICE=\"$(cat /etc/hostname)\"" > ./device_profile
	echo "ARCH=\"$(uname -m | sed 's/aarch64/arm64/g')\"" >> ./device_profile
	OPTFLAGS="$(gcc -### -E - -march=native 2>&1 | sed -r '/cc1/!d;s/(\")|(^.* - )//g' | sed 's/ -dumpbase -//g')"
	echo "OPTFLAGS=\"$OPTFLAGS\"" >> ./device_profile
	echo "KCFLAGS=\"-pipe\"" >> ./device_profile
	exit
else
	. ./device_profile
	export DEVICE=$DEVICE
	export ARCH=$ARCH
	export OPTFLAGS=$OPTFLAGS
	export KCFLAGS=$KCFLAGS
fi

# Create build dir if needed
[ -d ../build/$DEVICE ] || mkdir -p ../build/$DEVICE

# Cross compilation if needed
if [ ! "$(uname -m | sed 's/aarch64/arm64/g')" == "$ARCH" ]; then
	[ "$ARCH" == "arm" ] && export CROSS_COMPILE=arm-none-eabi-
	[ "$ARCH" == "arm64" ] && export CROSS_COMPILE=aarch64-linux-gnu-
	[ "$ARCH" == "riscv" ] && export CROSS_COMPILE=riscv64-linux-gnu-
fi

if [ "$1" == "build" ]; then
	make O=../build/$DEVICE KCFLAGS="$KCFLAGS $OPTFLAGS" -j $CORES
elif [ "$1" == "dtb" ]; then
	make O=../build/$DEVICE dtbs
elif [ "$1" == "cfg" ]; then
	if [ -z "$2" ]; then
		ls ./arch/$ARCH/configs
		exit
	fi
	echo "cp ./arch/$ARCH/configs/$2 .config"
	cp ./arch/$ARCH/configs/$2 ../build/$DEVICE/.config
elif [ "$1" == "config" ]; then
	make O=../build/$DEVICE nconfig
elif [ "$1" == "generate" ]; then
	rm -rf /tmp/kernel/
	mkdir /tmp/kernel
	mkdir /tmp/kernel/{boot,usr,lib}
	ln -s /tmp/kernel/lib /tmp/kernel/usr/lib
	export INSTALL_MOD_PATH=/tmp/kernel
	export INSTALL_DTBS_PATH=/tmp/kernel/boot
	make O=../build/$DEVICE modules_install -j $CORES
	make O=../build/$DEVICE dtbs_install -j $CORES
	cp ../build/$DEVICE/arch/$ARCH/boot/Image /tmp/kernel/boot/
	cp ../build/$DEVICE/arch/$ARCH/boot/Image.gz /tmp/kernel/boot/
elif [ "$1" == "install" ]; then
	[ ! -d /tmp/kernel ] && echo "Please generate the necessary files first" && exit
	KNAME=$(ls /tmp/kernel/usr/lib/modules)

	echo "Installing modules..."
	doas rsync -ravz --delete /tmp/kernel/usr/lib/modules/$KNAME/ /usr/lib/modules/$KNAME

	echo "Installing kernel..."
	doas cp /tmp/kernel/boot/Image /boot/Image
elif [ "$1" == "patch" ]; then
	b4 am -o- $2 | git am
elif [ "$1" == "update" ]; then
	git pull
elif [ "$1" == "clean" ]; then
	make O=../build/$DEVICE clean
	make mrproper
else
	echo -e "Available arguments:"
	echo -e "build\t - builds the kernel"
	echo -e "dtb\t - builds device trees"
	echo -e "cfg\t - lists available configs, run cfg someconfig_defconfig to load the config"
	echo -e "config\t - configure the kernel with nconfig"
	echo -e "generate - generates kernel files"
	echo -e "install\t - installs the kernel (local only at the moment)"
	echo -e "update\t - update the repository"
	echo -e "patch - apply patch from mailing list url"
	echo -e "clean\t - cleans up everything"
fi
