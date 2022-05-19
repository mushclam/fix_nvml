#!/bin/bash
# Lab: IRR
# Author: Jinwook Park
# Fix code for NVIDIA Driver/library version mismatch error

# Check sudoer
if [ $(id -u) -ne 0 ]
then
	exec sudo bash "$0" "$@"
	exit
fi

# Terminate conflictable process
echo "Check the existence of conflicts..."
RUNNING=(`lsof -Fp /dev/nvidia* | grep '^p'`)
if [ ! -z "$RUNNING" ]
then
	echo "Number of conflictable process: ${#RUNNING[@]}"
	echo "Terminate conflictable process..."
	for PROCESS in ${RUNNING[@]}
	do
		echo "PID: ${PROCESS##p}"
		kill -9 ${PROCESS##p}
	done
	echo "DONE."
else
	echo "No Conflicts."
fi

# Remove mod
echo -n "Remove conflict modules..."
MODS=("nvidia_uvm" "nvidia_drm" "nvidia_modeset" "nvidia")
for MOD in ${MODS[@]}
do     
       	echo -n "$MOD..."
	rmmod $MOD
done
echo "DONE."
echo "Check: nvidia-smi"
nvidia-smi
exit
