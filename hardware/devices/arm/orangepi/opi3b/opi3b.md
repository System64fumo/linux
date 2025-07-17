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

<details>
  <summary>Power consumption</summary>

  Bare board: `1.10w`<br>
  Maxed out: `5.13w`<br><br>

  ### Bare board
  Board powered on in a headless environment and the CPU set to powersave governor.<br>
  No desktop, No HDMI, No external peripherals, Passive cooling, MicroSD boot device, No Wireless/Wired communication.<br>

  ### Maxed out
  GUI desktop and CPU set to performance governor.<br>
  glmark2-wayland, stress --vm 4 --vm-bytes 128M -c 4, iperf3 --bidir, And active cooling.<br>

  ### Notes
  Unfortunately i don't have another M.2 SSD to test this with so storage/Disk IO is omitted from this test.<br>
  WiFi doesn't seem to work in mainline, Unless i'm doing something wrong, Radio (WiFi/Bluetooth) are omitted.<br>
  NPU Driver is not in mainline currently so that's also omitted.<br>
</details>

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
| WiFi         | 🔴 Broken   | Reports missing firmware                |
| Bluetooth    | 🟢 Works    |                                         |
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
