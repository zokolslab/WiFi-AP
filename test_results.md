
## Intro

Testing was done using the WiFi-AP setup script from (https://github.com/zokolslab/WiFi-AP/tree/main)

OS: Ubuntu 22.04 (running on VMWare Workstation Pro)

## Tested WiFi-adapters:

### TP-Link T3U Plus

Adapter can be set to AP-mode, but driver causes kernel fault.

```
[   21.511750] usb 2-1: new high-speed USB device number 2 using ehci-pci
[   21.868098] usb 2-1: New USB device found, idVendor=2357, idProduct=0138, bcdDevice= 2.10
[   21.868106] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   21.868108] usb 2-1: Product: 802.11ac NIC
[   21.868109] usb 2-1: Manufacturer: Realtek
[   21.868110] usb 2-1: SerialNumber: 123456
[   21.960324] rtw_8822bu 2-1:1.0: Firmware version 27.2.0, H2C version 13
[   21.961069] BUG: kernel NULL pointer dereference, address: 0000000000000004
[   21.961073] #PF: supervisor read access in kernel mode
[   21.961074] #PF: error_code(0x0000) - not-present page
[   21.961076] PGD 0 P4D 0 
[   21.961078] Oops: 0000 [#1] PREEMPT SMP NOPTI
[   21.961081] CPU: 0 PID: 245 Comm: kworker/u256:28 Not tainted 6.5.0-28-generic #29~22.04.1-Ubuntu
[   21.961083] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
[   21.961084] Workqueue: rtw88_usb: rx wq rtw_usb_rx_handler [rtw88_usb]
[   21.961091] RIP: 0010:rtw_rx_fill_rx_status+0x5b/0x350 [rtw88_core]
[   21.961107] Code: 00 48 89 45 d0 31 c0 48 83 e7 f8 48 c7 01 00 00 00 00 48 c7 41 28 00 00 00 00 48 29 f9 83 c1 30 c1 e9 03 f3 48 ab 48 8b 42 18 <8b> 48 04 0f b7 43 1c 66 81 e1 ff 1f 66 25 00 e0 09 c8 66 89 43 1c
[   21.961109] RSP: 0018:ffffb76e809bfcc8 EFLAGS: 00010206
[   21.961110] RAX: 0000000000000000 RBX: ffffb76e809bfda0 RCX: 0000000000000000
[   21.961112] RDX: ffff98e38d580900 RSI: ffffb76e809bfdd0 RDI: ffffb76e809bfdd0
[   21.961113] RBP: ffffb76e809bfd28 R08: ffff98e3868a0038 R09: 0000000000000000
[   21.961114] R10: 0000000000000000 R11: 0000000000000000 R12: ffff98e3868a0000
[   21.961115] R13: ffff98e38d582060 R14: ffffb76e809bfdd0 R15: ffff98e38d582060
[   21.961116] FS:  0000000000000000(0000) GS:ffff98e3b9e00000(0000) knlGS:0000000000000000
[   21.961118] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   21.961119] CR2: 0000000000000004 CR3: 000000010a080000 CR4: 0000000000750ef0
[   21.961145] PKRU: 55555554
[   21.961206] Call Trace:
[   21.961208]  <TASK>
[   21.961210]  ? show_regs+0x6d/0x80
[   21.961226]  ? __die+0x24/0x80
[   21.961236]  ? page_fault_oops+0x99/0x1b0
[   21.961238]  ? do_user_addr_fault+0x31d/0x6b0
[   21.961239]  ? exc_page_fault+0x83/0x1b0
[   21.961242]  ? asm_exc_page_fault+0x27/0x30
[   21.961247]  ? rtw_rx_fill_rx_status+0x5b/0x350 [rtw88_core]
[   21.961259]  ? update_load_avg+0x82/0x850
[   21.961263]  rtw8822b_query_rx_desc+0x147/0x200 [rtw88_8822b]
[   21.961267]  rtw_usb_rx_handler+0xc7/0x210 [rtw88_usb]
[   21.961271]  process_one_work+0x23d/0x450
[   21.961274]  worker_thread+0x50/0x3f0
[   21.961275]  ? __pfx_worker_thread+0x10/0x10
[   21.961277]  kthread+0xef/0x120
[   21.961279]  ? __pfx_kthread+0x10/0x10
[   21.961281]  ret_from_fork+0x44/0x70
[   21.961284]  ? __pfx_kthread+0x10/0x10
[   21.961286]  ret_from_fork_asm+0x1b/0x30
[   21.961289]  </TASK>
[   21.961289] Modules linked in: rtw88_8822bu(+) rtw88_usb rtw88_8822b rtw88_core mac80211 libarc4 cfg80211 bnep vsock_loopback vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport vsock intel_rapl_msr intel_rapl_common vmw_balloon intel_uncore_frequency_common binfmt_misc nls_iso8859_1 crct10dif_pclmul polyval_clmulni polyval_generic ghash_clmulni_intel sha256_ssse3 sha1_ssse3 aesni_intel snd_ens1371 crypto_simd snd_ac97_codec gameport ac97_bus cryptd rapl snd_pcm btusb btrtl btbcm btintel snd_seq_midi btmtk snd_seq_midi_event snd_rawmidi joydev input_leds serio_raw snd_seq bluetooth snd_seq_device snd_timer ecdh_generic snd ecc soundcore vmw_vmci mac_hid sch_fq_codel vmwgfx drm_ttm_helper ttm drm_kms_helper msr parport_pc ppdev lp parport drm efi_pstore ip_tables x_tables autofs4 hid_generic crc32_pclmul psmouse usbhid hid ahci mptspi libahci mptscsih mptbase e1000 scsi_transport_spi i2c_piix4 pata_acpi floppy
[   21.961322] CR2: 0000000000000004
[   21.961324] ---[ end trace 0000000000000000 ]---
[   21.961325] RIP: 0010:rtw_rx_fill_rx_status+0x5b/0x350 [rtw88_core]
[   21.961336] Code: 00 48 89 45 d0 31 c0 48 83 e7 f8 48 c7 01 00 00 00 00 48 c7 41 28 00 00 00 00 48 29 f9 83 c1 30 c1 e9 03 f3 48 ab 48 8b 42 18 <8b> 48 04 0f b7 43 1c 66 81 e1 ff 1f 66 25 00 e0 09 c8 66 89 43 1c
[   21.961337] RSP: 0018:ffffb76e809bfcc8 EFLAGS: 00010206
[   21.961338] RAX: 0000000000000000 RBX: ffffb76e809bfda0 RCX: 0000000000000000
[   21.961339] RDX: ffff98e38d580900 RSI: ffffb76e809bfdd0 RDI: ffffb76e809bfdd0
[   21.961340] RBP: ffffb76e809bfd28 R08: ffff98e3868a0038 R09: 0000000000000000
[   21.961341] R10: 0000000000000000 R11: 0000000000000000 R12: ffff98e3868a0000
[   21.961342] R13: ffff98e38d582060 R14: ffffb76e809bfdd0 R15: ffff98e38d582060
[   21.961342] FS:  0000000000000000(0000) GS:ffff98e3b9e00000(0000) knlGS:0000000000000000
[   21.961343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   21.961344] CR2: 0000000000000004 CR3: 000000010a080000 CR4: 0000000000750ef0
[   21.961360] PKRU: 55555554
[   21.961361] note: kworker/u256:28[245] exited with irqs disabled
[   26.290619] usbcore: registered new interface driver rtw_8822bu
[   26.306191] rtw_8822bu 2-1:1.0 wlxa842a159c044: renamed from wlan0
[   28.946898] audit: type=1400 audit(1715066600.615:53): apparmor="DENIED" operation="capable" class="cap" profile="/snap/snapd/21465/usr/lib/snapd/snap-confine" pid=1638 comm="snap-confine" capability=12  capname="net_admin"
[   28.947034] audit: type=1400 audit(1715066600.615:54): apparmor="DENIED" operation="capable" class="cap" profile="/snap/snapd/21465/usr/lib/snapd/snap-confine" pid=1638 comm="snap-confine" capability=38  capname="perfmon"
[   29.102498] rfkill: input handler enabled
[   33.269736] warning: `wpa_supplicant' uses wireless extensions which will stop working for Wi-Fi 7 hardware; use nl80211
[   33.850802] rfkill: input handler disabled
[   34.522578] ISO 9660 Extensions: Microsoft Joliet Level 3
[   34.522750] ISO 9660 Extensions: RRIP_1991A
[   36.297448] input: VMware DnD UInput pointer as /devices/virtual/input/input6
[   48.868231] rtw_8822bu 2-1:1.0: failed to get tx report from firmware
[   93.353877] usb 2-1: USB disconnect, device number 2
```

### TP-link TL-WN725N

Chipset: RTL8188EU

Failed to bring up interface
```
root@debian# ip link set wlx5c628b257f31 up
RTNETLINK answers: Operation not permitted
+ 'Error: Failed to bring up wlx5c628b257f31'

touko 06 12:27:47 red hostapd[4488]: nl80211: Could not configure driver mode
touko 06 12:27:47 red hostapd[4488]: nl80211: deinit ifname=wlx5c628b257f31 disabled_11b_rates=0
touko 06 12:27:47 red hostapd[4488]: nl80211 driver initialization failed.
touko 06 12:27:47 red hostapd[4488]: wlx5c628b257f31: interface state UNINITIALIZED->DISABLED
touko 06 12:27:47 red hostapd[4488]: wlx5c628b257f31: AP-DISABLED
touko 06 12:27:47 red hostapd[4488]: wlx5c628b257f31: CTRL-EVENT-TERMINATING
touko 06 12:27:47 red hostapd[4488]: hostapd_free_hapd_data: Interface wlx5c628b257f31 wasn't started
touko 06 12:27:47 red systemd[1]: hostapd.service: Control process exited, code=exited, status=1/FAILURE
```

## TP-Link TL-WN722N

Chipset: nl80211

Interface is detected by the OS, but hostapd cannot initialize the driver
```
touko 06 12:13:32 red hostapd[3636]: nl80211: Could not configure driver mode
touko 06 12:13:32 red hostapd[3636]: nl80211: deinit ifname=wlx3c52a1e22224 disabled_11b_rates=0
touko 06 12:13:32 red hostapd[3636]: nl80211 driver initialization failed.
touko 06 12:13:32 red hostapd[3636]: wlx3c52a1e22224: interface state UNINITIALIZED->DISABLED
touko 06 12:13:32 red hostapd[3636]: wlx3c52a1e22224: AP-DISABLED
touko 06 12:13:32 red hostapd[3636]: wlx3c52a1e22224: CTRL-EVENT-TERMINATING
touko 06 12:13:32 red hostapd[3636]: hostapd_free_hapd_data: Interface wlx3c52a1e22224 wasn't started
touko 06 12:13:32 red systemd[1]: hostapd.service: Control process exited, code=exited, status=1/FAILURE
```
## TP-Link Archer T3UNano 

Chipset: RTL8188EU

Hostapd started correctly, but could not keep any clients
```
touko 06 12:17:03 red systemd[1]: Started Access point and authentication server for Wi-Fi and Ethernet.
░░ Subject: A start job for unit hostapd.service has finished successfully
░░ Defined-By: systemd
░░ Support: http://www.ubuntu.com/support
░░ 
░░ A start job for unit hostapd.service has finished successfully.
░░ 
░░ The job identifier is 69464.
touko 06 12:18:06 red hostapd[4201]: wlx788cb5c5122e: STA 46:e0:68:1e:7f:db IEEE 802.11: authenticated
touko 06 12:18:06 red hostapd[4201]: wlx788cb5c5122e: STA 46:e0:68:1e:7f:db IEEE 802.11: authenticated
touko 06 12:18:06 red hostapd[4201]: wlx788cb5c5122e: STA 46:e0:68:1e:7f:db IEEE 802.11: authenticated
touko 06 12:18:06 red hostapd[4201]: wlx788cb5c5122e: STA 46:e0:68:1e:7f:db IEEE 802.11: authenticated
touko 06 12:18:06 red hostapd[4201]: wlx788cb5c5122e: STA 46:e0:68:1e:7f:db IEEE 802.11: associated (aid 1)
touko 06 12:18:06 red hostapd[4201]: wlx788cb5c5122e: STA 46:e0:68:1e:7f:db RADIUS: starting accounting session DE4AD714668AF606
touko 06 12:21:01 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 IEEE 802.11: did not acknowledge authentication response
touko 06 12:21:01 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 IEEE 802.11: associated (aid 2)
touko 06 12:21:01 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 RADIUS: starting accounting session F5CC4BCE50108335
touko 06 12:21:07 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 IEEE 802.11: disassociated
touko 06 12:21:08 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 IEEE 802.11: deauthenticated due to inactivity (timer DEAUTH/REMOVE)
touko 06 12:21:11 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 IEEE 802.11: authenticated
touko 06 12:21:12 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 IEEE 802.11: associated (aid 2)
touko 06 12:21:12 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 RADIUS: starting accounting session 548D39107A882CD6
touko 06 12:22:01 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 IEEE 802.11: authenticated
touko 06 12:22:01 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 IEEE 802.11: associated (aid 2)
touko 06 12:22:01 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 RADIUS: starting accounting session 548D39107A882CD6
touko 06 12:22:07 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 IEEE 802.11: disassociated
touko 06 12:22:08 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 IEEE 802.11: deauthenticated due to inactivity (timer DEAUTH/REMOVE)
touko 06 12:22:11 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 IEEE 802.11: authenticated
touko 06 12:22:11 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 IEEE 802.11: associated (aid 2)
touko 06 12:22:11 red hostapd[4201]: wlx788cb5c5122e: STA 8c:85:90:4e:9d:46 RADIUS: starting accounting session 3FACE513BA8BC925
```



### Alfa AWUS2100-H-38B6

Hostapd failed to set device into AP-mode
```
root@debian# hostapd -d /etc/hostapd/hostapd.conf 
random: getrandom() support available
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=0
nl80211: Supported cipher 00-0f-ac:1
nl80211: Supported cipher 00-0f-ac:5
nl80211: Supported cipher 00-0f-ac:2
nl80211: Supported cipher 00-0f-ac:4
nl80211: Supported cipher 00-0f-ac:10
nl80211: Supported cipher 00-0f-ac:8
nl80211: Supported cipher 00-0f-ac:9
nl80211: Using driver-based off-channel TX
nl80211: Driver-advertised extended capabilities (default) - hexdump(len=8): 00 00 00 00 00 00 00 40
nl80211: Driver-advertised extended capabilities mask (default) - hexdump(len=8): 00 00 00 00 00 00 00 40
nl80211: key_mgmt=0x1ff0f enc=0xef auth=0x7 flags=0xa40005104b03d0a0 rrm_flags=0x10 probe_resp_offloads=0x0 max_stations=0 max_remain_on_chan=5000 max_scan_ssids=4
nl80211: interface wlx00c0ca4f0309 in phy phy0
nl80211: Set mode ifindex 4 iftype 3 (AP)
nl80211: Failed to set interface 4 to mode 3: -95 (Operation not supported)
nl80211: Try mode change after setting interface down
nl80211: Set mode ifindex 4 iftype 3 (AP)
nl80211: Failed to set interface 4 to mode 3: -95 (Operation not supported)
nl80211: Interface mode change to 3 from 0 failed
nl80211: Could not configure driver mode
nl80211: deinit ifname=wlx00c0ca4f0309 disabled_11b_rates=0
nl80211: Remove monitor interface: refcount=0
netlink: Operstate: ifindex=4 linkmode=0 (kernel-control), operstate=6 (IF_OPER_UP)
nl80211: Set mode ifindex 4 iftype 2 (STATION)
nl80211 driver initialization failed.
hostapd_interface_deinit_free(0x561f94f009e0)
hostapd_interface_deinit_free: num_bss=1 conf->num_bss=1
hostapd_interface_deinit(0x561f94f009e0)
wlx00c0ca4f0309: interface state UNINITIALIZED->DISABLED
hostapd_bss_deinit: deinit bss wlx00c0ca4f0309
wlx00c0ca4f0309: AP-DISABLED 
hostapd_cleanup(hapd=0x561f94f02190 (wlx00c0ca4f0309))
wlx00c0ca4f0309: CTRL-EVENT-TERMINATING 
hostapd_free_hapd_data: Interface wlx00c0ca4f0309 wasn't started
hostapd_interface_deinit_free: driver=(nil) drv_priv=(nil) -> hapd_deinit
hostapd_interface_free(0x561f94f009e0)
hostapd_interface_free: free hapd 0x561f94f02190
hostapd_cleanup_iface(0x561f94f009e0)
hostapd_cleanup_iface_partial(0x561f94f009e0)
hostapd_cleanup_iface: free iface=0x561f94f009e0

```
### Ralink rt2x00

Could not set link up
```
root@debian# ip link set wlx70f11c299f33 up
RTNETLINK answers: No such file or directory
```

## Asus USB-AX56

Drivers do not seem to enable the network interface mode, with just initializing the mass storage mode of the USB-device.
```
[ 3158.666418] usb 2-2: new high-speed USB device number 5 using ehci-pci
[ 3158.946062] usb 2-2: New USB device found, idVendor=0bda, idProduct=1a2b, bcdDevice= 0.00
[ 3158.946069] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 3158.946071] usb 2-2: Product: DISK
[ 3158.946072] usb 2-2: Manufacturer: Realtek
[ 3159.005571] usb-storage 2-2:1.0: USB Mass Storage device detected
[ 3159.016576] scsi host33: usb-storage 2-2:1.0
[ 3159.016836] usbcore: registered new interface driver usb-storage
[ 3159.019115] usbcore: registered new interface driver uas
[ 3159.728495] usb 2-2: USB disconnect, device number 5

```
