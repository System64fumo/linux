# Orange Pi 5 Plus
<img align="right" src="https://github.com/System64fumo/linux/blob/main/assets/orangepi-5-plus.png" width="400">

Manufacturer: Orange Pi<br/>
SoC: RK3588<br/>
CPU: 4x A76 @ 2.4GHz + 4x A55 @ 1.8GHz<br/>
RAM: 4GB | 8GB | 16GB | 32GB<br/>
GPU: Mali G610 MC4<br/>
NPU: 6.0 TOPs<br/>
Storage: M.2 M key | EMMC | MicroSD<br/>
Network: 2x 2.5Gig Ethernet<br/>

<br/><br/><br/>

# Mainline support
| linux-next   | Status      | Notes                                             |
|--------------|-------------|---------------------------------------------------|
| Mainline     | 🟢 Works    |                                                   |
| CPU          | 🟢 Works    |                                                   |
| RAM          | 🟢 Works    |                                                   |
| GPU          | 🟢 Works    |                                                   |
| NPU          | 🔴 Broken   | No driver                                         |
| HW Encode    | ⚫ Untested | Should work but i've not tested it                |
| HW Decode    | ⚫ Untested | Same as above                                     |
| HDMI In      | 🔴 Broken   | Needs device tree entry but should in theory work |
| HDMI Out     | 🟢 Works    | Both HDMI out ports work                          |
| HDMI Audio   | 🟢 Works    |                                                   |
| Micro SD     | 🟢 Works    |                                                   |
| EMMC         | 🟢 Works    |                                                   |
| Ethernet     | 🟢 Works    |                                                   |
| Rear USB     | 🟢 Works    |                                                   |
| Font USB     | 🟢 Works    |                                                   |
| Audio Jack   | 🟢 Works    |                                                   |
| Speakers     | 🟢 Works    |                                                   |
| Microphone   | 🔴 Broken   |                                                   |
| RTC          | 🟢 Works    |                                                   |
| UART         | 🟢 Works    |                                                   |
| M.2 E Key    | 🟢 Work     |                                                   |
| M.2 M Key    | 🟢 Work     |                                                   |
| Thermals     | 🟢 Works    |                                                   |
| Fan control  | 🟢 Work     |                                                   |
| Power Button | 🟢 Works    |                                                   |
| GPIO         | ⚫ Untested |                                                   |
| LEDs         | 🟢 Works    |                                                   |
| IR           | ⚫ Untested |                                                   |
