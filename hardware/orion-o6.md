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

<br/><br/><br/><br/><br/><br/><br/><br/>

# Mainline support
| linux-next  | Status     | Notes                                                                                                                                 |
|-------------|------------|---------------------------------------------------------------------------------------------------------------------------------------|
| Mainline    | 🟢 Works    | ACPI boot only ATM                                                                                                                    |
| SoC         | 🟡 Partial  | Some cores run at [reduced](https://forum.radxa.com/t/clarification-about-the-o6-spec-change/26493) speeds (2.6GHz instead of 2.8GHz) |
| RAM         | 🟢 Works    | All memory is detected (up to 64gb)                                                                                                   |
| GPU         | 🔴 Broken   | Pending panthor driver [merge request](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/34032)                               |
| NPU         | 🔴 Broken   | No driver                                                                                                                             |
| HDMI        | 🟡 Partial  | EFI FB partially works (1080P@60Hz on most monitors)                                                                                  |
| DP          | 🟡 Partial  | Same as above                                                                                                                         |
| eDP         | 🟢 Works    | Confirmed working on a NE140QDM-NX1 panel                                                                                             |
| Storage     | 🟢 Works    | M.2 SSDs work as expected                                                                                                             |
| Network     | 🟢 Works    | Both 5 gig ports (rtl8126) work normally on Linux >6.9                                                                                |
| Front USB   | ⚫ Untested | -                                                                                                                                     |
| Rear USB    | 🟢 Works    | Not sure if it's on my end but some ports occasionally disconnect?                                                                    |
| Front audio | ⚫ Untested | -                                                                                                                                     |
| Rear audio  | 🔴 Broken   | -                                                                                                                                     |
| RTC         | 🟡 Partial  | Date seems to get loaded just fine but time doesn't?                                                                                  |
| UART        | 🟢 Works    | UART2 for Boot / Linux console                                                                                                        |
| PCIE        | 🟡 Partial  | Works fine for most devices but some GPUs don't get detected (see below)                                                              |

# Notes
This board is capable of booting pure mainline linux, It's also capable of utilizing some external Graphics cards.<br/>
Anything with a link is tested by someone other than me, Credits go to them.<br/>

| Device      | Status      | Notes                                                |
| ------------| ------------|------------------------------------------------------|
| RX 480      | 🟢 Works    | [Source](https://forum.radxa.com/t/problems-with-pcie-gen4-on-the-x8-slot/26615) |
| RX 580      | 🟢 Works    |                                                      |
| RX 7600     | 🟡 Partial? | [Works](https://forum.radxa.com/t/arm-workstation-build/25922) [Does not](https://forum.radxa.com/t/problems-with-pcie-gen4-on-the-x8-slot/26615) |
| RX 6500     | 🟡 Partial  | [Works but needs 6.15 kernel + 64k pages](https://forum.radxa.com/t/orion-o6-debug-party-invitation/25054/478) |
| RX 6700     | 🟡 Partial  | [Detected in linux but causes hang once driver loads](https://github.com/geerlingguy/sbc-reviews/issues/62#issuecomment-2852465195) |
| RX 7800     | 🔴 Broken   | UEFI does not detect the card neither does linux     |
| RX 7900     | 🟡 Partial  | [Detected in linux but causes hang once driver loads](https://github.com/geerlingguy/sbc-reviews/issues/62#issuecomment-2852451205) |
| WX 3100     | 🟢 Works    | [Source](https://x.com/intlinux/status/1884081756556628325) |
| GT 1030     | 🟢 Works    | [Source](https://x.com/mecoscorner/status/1916096610188067038) |
| GTX 1650    | 🟡 Partial  | Works in linux, Does not work in UEFI (Black screen) |
| RTX 3060    | 🟢 Works    | [Source](https://github.com/geerlingguy/sbc-reviews/issues/62#issuecomment-2799534109) |
| RTX 3080 TI | 🟡 Partial  | [Source](https://github.com/geerlingguy/sbc-reviews/issues/62#issuecomment-2852490521) |
| RTX 3090    | 🟢 Works    | [Source](https://x.com/mecoscorner/status/1910018752176857284) |
| RTX A400    | 🔴 Broken   | [Source](https://github.com/geerlingguy/sbc-reviews/issues/62#issuecomment-2836546822)
