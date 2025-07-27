# Optimization
Linux offers a lot of flexibility, But in doing so it also offers a lot of potential for improvement.<br>
Since kernel/distro maintainers can't guess where your installation of linux will be used general assumptions are made and safe options are choosen,
However those options may not always be the optimal ones.<br>

Here are some general tips for picking the right options.<br>

> [!NOTE]
> Some kernels don't include some of the features/configs listed here.<br>
> To check if your kernel offers something run `zcat /proc/config.gz | grep CONFIG_X`<br>
> where CONFIG_X is what the "Needs" section mentions.<br>

> [!IMPORTANT]  
> Please reference external sources since i'm no expert in any of this matter,<br>
> All of the data written here is from my own personal testing/experience.<br>

> [!CAUTION]
> Please read through each section and benchmark things yourself.<br>
> Blindly copy/pasting things from here may lead to undesirable behavior.<br>

<details>
  <summary><h2>Performance governors</h2></summary>

  It's common knowledge that your CPU/GPU runs at different clock speeds depending on the workload, But if you don't really care about energy efficiency and want to improve latency/performance
  you can switch to the performance governor.

  This can be done via:<br>
  CPU: `echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor`<br>
  Needs: `CONFIG_CPU_FREQ_GOV_PERFORMANCE`<br>

  GPU: `echo performance | tee /sys/class/devfreq/*.gpu/governor`<br>
  Needs: `CONFIG_DEVFREQ_GOV_PERFORMANCE`<br>

  Other: Same as GPU if available.
</details>


<details>
  <summary><h2>Heterogeneous systems (big.LITTLE)</h2></summary>

  On systems with slow/fast cores you may find that running a multi threaded process with all cores enabled is slower than running with just the fast cores.<br>
  This is usually not that noticable but can be a severe performance bottleneck in some systems.

  ## Why does this happen?
  When you run a multi threaded process on heterogeneous system, Your program will only run as fast as the slowest core it can access,
  So even if you have really fast cores, As long as one slow core is available for the program to use,
  The fast cores will have to wait until the slow core is done processing.<br>

  Additionally since the fast and slow cores "live on separate nodes" there's a slight data transfer penalty if the cores have to communicate with one another.<gr>

  ## How to mitigate this?
  To alivieate this you can limit which cores a program runs on by using the `taskset` command.<br>

  Example 1: `taskset -c 0-3 stress -c 4`<br>
  This will stress cores 0,1,2,3<br>

  Example 2: `taskset -c 4-7 stress -c 4`<br>
  This will stress cores 4,5,6,7<br>
</details>

<details>
  <summary><h2>Networking</h2></summary>
  Networking on linux can be complicated, There's far too much stuff to mess with or fine tune.<br>
  The following section has only been tested on small home networks,
  Your milage may vary on high end/many user networks.<br>
  (Please run benchmarks and tests and measure that there's a positive impact by the following changes/recommendations)
  
  ## Increasing throughput
  
  ### MTU
  Maximum Transmission Unit Refers to the largest size of a packet that can be sent over a network.<br>
  Ethernet tends to default to 1500, But most modern NICs support "Jumbo Frames" which is an MTU of 9000.<br>
  
  Larger MTU means you can pack more data into a single packet allowing for more throughput, HOWEVER this also means that if that packet is corrupt or dropped more data has to be re-transmitted.<br>
  It's generally recommended to set your MTU to the maximum your NIC supports for lossless networks. (Ethernet)<br>
  
  Example: `ip link set dev eth0 mtu 9000`<br>
  
  Note: If you have a bridge device be sure to also change it's MTU<br>
  
  ### Congestion control
  Congestion Control refers to how a machine handles high network traffic.<br>
  For wired networks i personally found out that H-TCP seems to be most reliable, But again this highly depends on your network and hardware so please double check.
  For wireless networks BBR or BIC might be better, Again please double check.
  
  [H-TCP](https://en.wikipedia.org/wiki/H-TCP) seems to offer the least drops/retries with highest real world bandwidth.<br>
  [BBR](https://research.google/pubs/bbr-congestion-based-congestion-control-2/)/[BIC](https://en.wikipedia.org/wiki/BIC_TCP) seem to offer lots of drops/retries with absurdly high "throughput".<br>
  
  Changing the algorithm:<br>
  H-TCP: `sysctl -w net.ipv4.tcp_congestion_control = htcp`<br>
  Needs: `CONFIG_TCP_CONG_HTCP`<br>
  
  BBR: `sysctl -w net.ipv4.tcp_congestion_control = bbr`<br>
  Needs: `CONFIG_TCP_CONG_BBR`<br>
  
  BIC: `sysctl -w net.ipv4.tcp_congestion_control = bic`<br>
  Needs: `CONFIG_TCP_CONG_BIC`<br>
  
  ## Reducing latency
  
  ### QoS
  Quality of Service refers to how a machine handles network packet classification.<br>
  From my testing i found that FQ-Codel seems to be the best choice all around, But in some cases CAKE might be the other best alternative.<br>
  
  Changing the algorithm:<br>
  FQ-Codel: `tc qdisc replace dev eth0 root fq_codel`<br>
  Needs: `CONFIG_NET_SCH_FQ_CODEL`<br>
  
  CAKE: `tc qdisc replace dev eth0 root cake`<br>
  Needs: `CONFIG_NET_SCH_CAKE`<br>
</details>
