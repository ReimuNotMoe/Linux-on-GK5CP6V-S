#!/bin/bash


case $1 in
	nvfreq)
		if [ ! -e /sys/module/nvidia ]; then
			echo Warning: Discrete GPU turned off. Not adjusting GPU clocks.
			exit 1
		fi
		if [ -z "$2" ]; then
			nvidia-smi -rgc
		else
			nvidia-smi -lgc "$2"
		fi
	;;
	cpufreq)
		for i in {0..11}; do
			cpufreq-set -c $i -g "$2" -u "$3" > /dev/null 2> /dev/null
		done
	;;

	cpupwr)
		for (( i=$2; i<=$3; i++ )); do
			echo $4 > /sys/devices/system/cpu/cpu$i/online
		done
	;;


	reset)
		$0 cpupwr 1 11 1
		$0 cpufreq powersave 4.5G
		$0 nvfreq
	;;

	powersave)
		$0 cpufreq powersave 800M
		$0 nvfreq 300,600
	;;

	powersaveX)
		$0 cpufreq powersave 800M
		$0 cpupwr 1 5 1
		$0 cpupwr 6 11 0
		$0 nvfreq 300,450
	;;

	powersaveX2)
		$0 cpufreq powersave 800M
		$0 cpupwr 1 3 1
		$0 cpupwr 4 11 0
		$0 nvfreq 0,75
	;;

	performance)
		$0 cpupwr 1 11 1
		$0 cpufreq performance 4.5G
		$0 nvfreq
	;;

	performanceX)
		$0 cpupwr 1 11 1
		$0 cpufreq performance 4.5G
		$0 nvfreq 1000,2100
	;;
esac

