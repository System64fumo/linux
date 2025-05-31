# Orange Pi 3B
<img align="right" src="https://github.com/System64fumo/linux/blob/main/assets/orangepi-3b.png" width="400">

Manufacturer: Orange Pi<br/>
SoC: RK3566<br/>
CPU: 4x A55 @ 1.8GHz<br/>
RAM: 2GB | 4GB | 8GB<br/>
GPU: Mali G52 MP2<br/>
NPU: 0.8 TOPs<br/>
Storage: M.2 M key | EMMC | MicroSD<br/>
Network: 1Gig Ethernet | WiFi 5 | Bluetooth 5<br/>

<br/>

# Mainline support
| linux-next   | Status      | Notes                                   |
|--------------|-------------|-----------------------------------------|
| Mainline     | 🟢 Works    |                                         |
| CPU          | 🟢 Works    |                                         |
| RAM          | 🟢 Works    |                                         |
| GPU          | 🟢 Works    |                                         |
| NPU          | 🔴 Broken   | No driver                               |
| HW Encode    | ⚫ Untested | Should work but i've not tested it      |
| HW Decode    | ⚫ Untested | Same as above                           |
| HDMI         | 🟢 Works    |                                         |
| Micro SD     | 🟢 Works    |                                         |
| Ethernet     | 🟢 Works    |                                         |
| WiFi         | 🟢 Works    | Reports missing firmware but works fine |
| Bluetooth    | ⚫ Untested | Likely working                          |
| Rear USB     | 🟢 Works    |                                         |
| Audio Jack   | 🟢 Works    |                                         |
| RTC          | 🟢 Works    |                                         |
| UART         | 🟢 Works    |                                         |
| M.2 E Key    | ⚫ Untested |                                         |
| Thermals     | 🟢 Works    |                                         |
| Fan control  | 🔴 Broken   |                                         |
| Power Button | 🟢 Works    |                                         |
| GPIO         | ⚫ Untested |                                         |
| LEDs         | 🟢 Works    |                                         |
