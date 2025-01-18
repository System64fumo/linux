# Bootloaders

# EFI
The Extensible Firmware Interface is what most people are used to as it's what modern x86_64 systems use.<br>
However what most people don't know is that you can use it to load linux directly!<br>

An example script is available [here](../scripts/efi.sh). (Be sure to modify it)<br>

# U-Boot
[U-Boot Documentation](https://docs.u-boot.org/en/latest/index.html) is actually great, No need to rephrase their docs.<br>
I will add a build script here eventually..

# Android
Android devices tend to use a file called boot.img that usually contains a kernel and initramfs.<br>
Some also contain device trees in there, In other cases device trees are stored in the DTBO partition.<br>

To create an Android boot.img you can use `mkbootimg` and to extract existing ones you can use `unpack_bootimg`<br>
Both executables are provided by the `android-tools` package.<br>

An example script to boot linux on Android devices can be found [here](../scripts/bootimg.sh).<br>
