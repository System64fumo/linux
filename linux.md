# Linux

<details>
  <summary>General knowledge</summary>

# Configs
The kernel config defines what features the kernel has at build time.<br>
You can view what config you're running on your system right now by running `zcat /proc/config.gz`<br>
In the future i'll add a place for people to submit their configs to this repo.<br>

# Modules
Modules can usually be set to 3 different states:<br>
1. `[ ]` Disabled - The module will not be built or included and cannot be used later<br>
2. `[m]` Module - The module will be built but will only be loaded or used if needed<br>
3. `[*]` Baked in - The module will always be loaded<br>

Disabling features you usually don't use will reduce the time it takes to compile and reduce the size of the kernel.<br>
But it also means that you won't be able to use whatever feature you disabled at a later time without recompiling the kernel.<br>

Modules are great since you can build basically everything and only load what you need and use dynamically.<br>
However this sometimes means you have to rely on initramfs to load storage or filesystem modules.<br>

Baking in modules is usually good critical or important modules such as storage, filesystems, framebuffer, ect..<br>
Of course baking in everything is a terrible idea as it wastes memory if you're not using something.<br>
<br>

# Sources & Forks
There are tons of forks out there, Most notably being vendor kernels and mainline forks.<br>
Vendor kernels are typically kernels provided by the OEM to be used by the specific board they provide.<br>
Those forks tend to have device specific configs that only include support for hardware relevant to that platform.<br>

Vendor kernels are sadly known to be very outdated and horrible to use,<br>
You either need an old version of gcc to compile them, Or they outright don't compile at all.<br>

Mainline forks on the otherhand are kernels for development and testing patches before they are sent to mainline.<br>
These kernels tend to use more or less the latest version of linux available at the time.<br>
</details>

<details>
  <summary>Helper script</summary>
<br>

# Helper script
Linux compilation is sometimes tedious or annoying, So i wrote a [helper script](./scripts/kbuild.sh) to streamline a bit of that workflow.<br>

### Functions:
* build - builds the kernel
* dtb - only compiles/recompiles device trees (In case you made changes)
* cfg - if no argument is specified it will list available kernel configs (eg: defconfig) otherwise it will load the specified config
* config - shows a configuration menu
* generate - generates the necessary files for installation
* install - installs the kernel
* update - updates the kernel repository
* patch - applies a patch from a mailing list
* clean - cleans the build
<br>

### Features:
* automatic cross compilation - You need to run `kbuild.sh clean` if you start compiling on one arch and continue on another
* native optimizations - There are some compile flags that are specific to some architectures
* device profiles - Builds are separated into their own folder allowing you to build different kernels for different devices from the same repository

> **Note**<br>
> When creating a profile the native optimizations will use what's appropriate for the machine running the command.<br>
> So generate device_profile on the target machine and copy it to the compiler machine.

> **Note**<br>
> When generating the kernel files it will copy everything you need to /tmp/kernel. (Device tree support will come soon)<br>
> You can then copy those files to your target device.
</details>

<details>
  <summary>Compiling</summary>

# Compiling

1. Start by downloading or cloning a kernel.<br>
`git clone --depth 1 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git`<br>

2. Navigate to the kernel directory.<br>
`cd linux`

3. Generate __device_profile__ by running.<br>
`kbuild.sh`

4. List and select a config.<br>
`kbuild.sh cfg` then `kbuild.sh cfg yourconfig` (eg. defconfig)<br>

5. (Optional) Customize the kernel.<br>
`kbuild.sh config`

6. Compile the kernel.<br>
`kbuild.sh build`

7. Generate necessary files.<br>
`kbuild.sh generate`

8. (Optional) Install to the current running system.<br>
`kbuild.sh`
<br>
</details>
