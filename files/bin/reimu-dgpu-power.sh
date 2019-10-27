#!/bin/bash


__off() {
	#if [ -e /sys/bus/pci/drivers/snd_hda_intel/0000:01:00.1 ]; then
	#	echo 0000:01:00.1 > /sys/bus/pci/drivers/snd_hda_intel/unbind || exit 2
	#fi
	#if [ -e /sys/bus/pci/drivers/xhci_hcd/0000:01:00.2 ]; then
	#	echo 0000:01:00.2 > /sys/bus/pci/drivers/xhci_hcd/unbind || exit 2
	#fi
	#lsmod|grep i2c_nvidia_gpu
	#if [ "$?" == "0" ]; then
	#	modprobe -r i2c_nvidia_gpu || exit 2
	#fi
	for i in 0000:01:00.3 0000:01:00.2 0000:01:00.1 0000:01:00.0; do
		echo 1 > /sys/bus/pci/devices/"$i"/remove
	done

	echo '\_SB.PCI0.PEG0.PEGP._OFF' > /proc/acpi/call
	cat /proc/acpi/call
	echo dGPU power turned off.
}

__on() {	
	echo '\_SB.PCI0.PEG0.PEGP._ON' > /proc/acpi/call
	cat /proc/acpi/call
	echo 1 > /sys/bus/pci/rescan
	#echo 0000:01:00.1 > /sys/bus/pci/drivers/snd_hda_intel/bind
	#echo 0000:01:00.2 > /sys/bus/pci/drivers/xhci_hcd/bind
	#modprobe i2c_nvidia_gpu
	echo dGPU power turned on.
}

__auto() {
	echo Doing auto config.
	prime_mode=`prime-select query`
	echo Current mode: "$prime_mode"
	if [ "$prime_mode" == "intel" ]; then
		__off
	else
		__on
	fi
}
modprobe acpi_call || exit 1

case $1 in
	off)
		__off
	;;
	on)
		__on
	;;
	*)
		__auto
	;;
esac

exit 0
