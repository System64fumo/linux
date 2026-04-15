# Orion O6
<img align="right" src="https://github.com/System64fumo/linux/blob/main/assets/orion-o6.png" width="400" height="400"/>

Manufacturer: Radxa<br/>
SoC: CIX CD8180<br/>
CPU: 4x A720 @ 2.6GHz + 4x A720 @ 2.4GHz + 4x A520 @ 1.8GHz<br/>
RAM: 8 | 16 | 32 | 64 GB<br/>
GPU: Immortals G720 MC10<br/>
NPU: 30 TOPs<br/>
Storage: M.2 M key (4.0 4x lanes)<br/>
Network: 2x 5Gig Ethernet  + M.2 E key (4.0 2x lanes)<br/>

> [!IMPORTANT]
> A community member [Neol00](https://github.com/Neol00/) made a custom [UEFI image](https://github.com/Neol00/edk2-cix-unlocked) which fixes a lot of major issues with the stock UEFI, Such as incorrect core layout, Incorrect core speeds, USB power related issues, Cache related issues, Among other things, Since this UEFI superceeds the official/stock's functionality/stability/performance i advise everyone to switch to it until the issues with the official/stock ones are fixed.

> [!CAUTION]
> The UEFI provided above *offers* overclocking functionality which __might damage board__ if you enter incorrect settings, __Please do not contact or blame radxa for any damage done to your board if you choose to overclock__, Do so at your own risk.

<br/><br/><br/><br/><br/><br/><br/><br/>

# Mainline support
| linux-next   | Status      | Notes                                                                                                                                 |
|--------------|-------------|---------------------------------------------------------------------------------------------------------------------------------------|
| Mainline     | 🟢 Works    | ACPI boot only ATM                                                                                                                    |
| CPU          | 🟡 Partial  | Some cores run at [reduced](https://forum.radxa.com/t/clarification-about-the-o6-spec-change/26493) speeds (2.6GHz instead of 2.8GHz) |
| RAM          | 🟢 Works    | All memory is detected (up to 64gb)                                                                                                   |
| GPU          | 🔴 Broken   | Pending panthor driver [merge request](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/34032)                               |
| NPU          | 🔴 Broken   | No driver                                                                                                                             |
| HW Encode    | 🔴 Broken   | No driver                                                                                                                             |
| HW Decode    | 🔴 Broken   | No driver                                                                                                                             |
| HDMI         | 🟡 Partial  | EFI FB partially works (1080P@60Hz on most monitors)                                                                                  |
| DP           | 🟡 Partial  | Same as above                                                                                                                         |
| eDP          | 🟡 Partial  | Same as above, Confirmed working on a NE140QDM-NX1 panel                                                                              |
| USB-C DP     | 🟡 Partial  | Same as above                                                                                                                         |
| Storage      | 🟢 Works    | M.2 SSDs work as expected                                                                                                             |
| Ethernet     | 🟢 Works    | Random chance of the drivers [crashing](https://forum.radxa.com/t/miscellaneous-testing/26642/13) on boot                             |
| Front USB    | 🟢 Works    | Needs [9.0.0 firmware](https://dl.radxa.com/orion/o6/images/bios/SystemReady/latest)                                                  |
| Rear USB     | 🟢 Works    | Not sure if it's on my end but some ports occasionally disconnect?                                                                    |
| Front audio  | ⚫ Untested |                                                                                                                                       |
| Rear audio   | 🔴 Broken   |                                                                                                                                       |
| RTC          | 🟢 Works    |                                                                                                                                       |
| UART         | 🟢 Works    | UART2 for Boot / Linux console                                                                                                        |
| PCIE         | 🟡 Partial  | Works fine for most devices but some GPUs don't get detected (see below)                                                              |
| M.2 E Key    | 🟢 Works    |                                                                                                                                       |
| M.2 M Key    | 🟢 Works    | Needs [1.0.0-1 firmware](https://github.com/radxa-pkg/edk2-cix/releases/tag/1.0.0-1)                                                  |
| Thermals     | 🟢 Works    | Needs [0.3.0-1 firmware](https://github.com/radxa-pkg/edk2-cix/releases/tag/0.3.0-1)                                                  |
| Fan control  | 🟡 Partial  | Auto fan control, No way to control from OS                                                                                           |
| Power Button | 🔴 Broken   |                                                                                                                                       |
| GPIO         | 🔴 Broken   |                                                                                                                                       |
| LEDs         | 🔴 Broken   |                                                                                                                                       |
| Touch Panel  | ⚫ Untested |                                                                                                                                       |

# Graphics Cards
This board can utilize *some* dedicated PCIE GPUs.<br/>
Please note that there are currently issues with pcie 4.0 devices and there are some issues with modern AMD GPUs.<br/>
Anything with a link is tested by someone other than me, Credits go to them.<br/>

| Device      | Status     | Notes                                                                                                                                             |
| ------------| -----------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| **AMD**     | 🟢 Works   | Modern cards (rx 7600/newer) may need X86EmulatorDxe in order to see things in UEFI                                                               |
| RX 480      | 🟢 Works   | [Source](https://forum.radxa.com/t/problems-with-pcie-gen4-on-the-x8-slot/26615)                                                                  |
| RX 560      | 🟢 Works   | [Source](https://forum.radxa.com/t/recommended-external-gpu-for-o6/26898/14)                                                                      |
| RX 580      | 🟢 Works   |                                                                                                                                                   |
| RX 5600     | 🟢 Works   |                                                                                                                                                   |
| RX 6400     | 🟢 Works   | [Source](https://forum.radxa.com/t/orion-o6s-pcie-x16-slot-wattage-12v-q/27262/8)                                                                 |
| RX 6500     | 🟢 Works   | [Works but needs 6.15 kernel](https://forum.radxa.com/t/orion-o6-debug-party-invitation/25054/494)                                                |
| RX 6600     | 🟢 Works   | [Works but needs 6.15 kernel](https://forum.radxa.com/t/orion-o6-debug-party-invitation/25054/496)                                                |
| RX 6700     | 🟢 Works   | Needs [9.0.0 firmware](https://forum.radxa.com/t/orion-o6-debug-party-invitation/25054/485) + Kernel patch                                        |
| RX 7600     | 🟢 Works   | [Works Source 1](https://forum.radxa.com/t/arm-workstation-build/25922) [Works Source 2](https://forum.radxa.com/t/issues-with-modern-graphics-cards/26891/7) |
| RX 7800     | 🔴 Broken  | UEFI does not detect the card neither does linux                                                                                                  |
| RX 7900     | 🟡 Partial | [Detected in linux but causes hang once driver loads](https://github.com/geerlingguy/sbc-reviews/issues/62#issuecomment-2852451205)               |
| RX 7900 XTX | 🟢 Works   | [Source](https://forum.radxa.com/t/recommended-external-gpu-for-o6/26898/12)                                                                      |
| RX 9060 XT  | 🟢 Works   | [Source](https://github.com/System64fumo/linux/pull/28)                                                                                           |
| WX 3100     | 🟢 Works   | [Source](https://x.com/intlinux/status/1884081756556628325)                                                                                       |
| **Nvidia**  | 🟢 Works   | Works in linux & UEFI when X86EmulatorDxe is available in EDK2 (tested by @HeyMeco)                                                               |
| GT 210      | 🟢 Works   |                                                                                                                                                   |
| GT 1030     | 🟢 Works   | [Source](https://x.com/mecoscorner/status/1916096610188067038)                                                                                    |
| GTX 1650    | 🟢 Works   |                                                                                                                                                   |
| GTX 1660 TI | 🟢 Works   | Tested by [kossLAN](https://github.com/kossLAN)                                                                                                   |
| RTX 3060    | 🟢 Works   | [Source](https://github.com/geerlingguy/sbc-reviews/issues/62#issuecomment-2799534109)                                                            |
| RTX 3070    | 🟢 Works   | [Source](https://github.com/System64fumo/linux/pull/28)                                                                                           |
| RTX 3070 TI | 🟢 Works   | [Source](https://forum.radxa.com/t/recommended-external-gpu-for-o6/26898/8)                                                                       |
| RTX 3080 TI | 🟡 Partial | [Source](https://github.com/geerlingguy/sbc-reviews/issues/62#issuecomment-2852490521)                                                            |
| RTX 3090    | 🟢 Works   | [Source](https://x.com/mecoscorner/status/1910018752176857284)                                                                                    |
| RTX 5050    | 🟢 Works   | [Source](https://github.com/System64fumo/linux/pull/18)                                                                                           |
| RTX 5080    | 🟢 Works   | [Works but needs latest firmware](https://forum.radxa.com/t/recommended-external-gpu-for-o6/26898/11)                                             |
| RTX A400    | 🔴 Broken  | [Source](https://github.com/geerlingguy/sbc-reviews/issues/62#issuecomment-2836546822)                                                            |
| **Intel**   | 🟡 Partial | Works but sometimes requires hard reset. Driver also needs patch                                                                                  |
| B580        | 🟡 Partial | Works in linux [Source](https://github.com/System64fumo/linux/pull/7#issuecomment-3068051539)                                                     |

# Network cards

| Device      | Status     | Notes                                                                                                                                             |
| ------------| -----------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| **Intel**   | 🟢 Works   | Some cards might need ASPM turned off                                                                                                             |
| 8265NGW     | 🟡 Partial | Works but needs ASPM turned off [Source](https://github.com/System64fumo/linux/pull/28)                                                                 |

# Storage controllers
There are multiple options to extend the storage beyond the M.2 E key. One of the options is to use a SAS based raid controller with support for HBA mode.  

### Raid controllers

| Device      | Status      | Notes
| ------------| ------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| **Fujitsu**  
| D3307-A12 | 🟢 Works      |  [Source](https://github.com/System64fumo/linux/issues/10)

### Sata controllers
| Device      | Status      | Notes
| ------------| ------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| **No Name**               |
| JMB582 based | 🟢 Works   |  [Source](https://github.com/System64fumo/linux/issues/14)
