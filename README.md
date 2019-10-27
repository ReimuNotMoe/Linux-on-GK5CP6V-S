# Linux on GK5CP6V-S
Quirks to make Linux work flawlessly on GK5CP6V-S based laptops.

There are chances for these quirks to work on other similar models, such as GK5CN5Z, GK5CN6Z, GK5CQ7Z, GK5CP0Z.

## Hardware
### Quick specs
Component | Description
 --- | --- 
CPU	| Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
dGPU	| NVIDIA Geforce GTX 1660 Ti
Screen	| 1080p60
Ethernet	| Realtek RTL8111/8168/8411
USB Ports	| 3 type A, 1 type C
Display Ports	| 1 HDMI 2.0, 2 miniDP, all wired to dGPU

### Known laptops based on this platform
- Hasee Z7-CT7VH
- Shinelon T3 Ti (Tongfang model, not Clevo)
- Some Mechrevo laptops


## Problems & Workarounds
All related files are in the [files](https://github.com/ReimuNotMoe/Linux-on-GK5CP6V-S/tree/master/files) directory.

As of kernel 5.3.7 + NVIDIA proprietary driver 440.26:

### Freeze when resuming from S3
This is caused by multiple crappy components or **their proprietary specs** :
- Touchpad
- Card reader
- USB Type-C power control(?) driver
- Faulty ACPI & IOMMU & MMCONFIG implementation and/or PCIe device drivers

Workarounds:
- Blacklist kmods for TypeC & Card reader (since they're not used by most people)
- Unload touchpad driver before suspend, and reload it after resume
- Kernel cmdline: `pci=nommconf acpi_osi=Linux intel_iommu=off`

### dGPU burning battery even when using only iGPU
It burns battery at 1 amps @ 12.5 volts. That's insane, please blame Tongfang HK.

Workaround:
- Use `acpi_call` to turn off its power after X11 startup ASAP.
- Don't use `bbswitch`, it will crash the system.

**Warning for TLP users**: Please blacklist all pci ids of the dGPU, otherwise the system will freeze when turning it off.
