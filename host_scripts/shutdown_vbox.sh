#!/bin/bash

# STOP ALL RUNNING VIRTUALBOX VMS
running_vms=$(VBoxManage list runningvms | sed -E 's/^"(.+)"\s+\{.+\}$/\1/')
if [ -z "$running_vms" ]; then
    echo "No VirtualBox VMs are currently running."
    exit 0
fi
echo "$running_vms"
IFS=$'\n'
for vm in $running_vms; do
    echo "Attempting ACPI shutdown of \"$vm\"..."
    VBoxManage controlvm "$vm" acpipowerbutton
    for i in {1..20}; do
        sleep 1
        if ! VBoxManage list runningvms | grep -q "\"$vm\""; then
            echo "\"$vm\" shut down successfully."
            break
        fi
    done
    if VBoxManage list runningvms | grep -q "\"$vm\""; then
        echo "\"$vm\" did not shut down gracefully. Forcing power off..."
        VBoxManage controlvm "$vm" poweroff
    fi
done
echo "All VMs have been shut down."