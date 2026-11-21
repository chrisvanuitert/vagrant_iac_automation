#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cancel() {
    echo -e "\n\nCancelled."
    exit 130
}
trap cancel INT TERM

running_vms="$(VBoxManage list runningvms 2>/dev/null || true)"

running_machines=()
for i in 1 2 3; do
    if echo "$running_vms" | grep -q "\"virtualmachine${i}\""; then
        running_machines+=("virtual_machine_${i}")
    fi
done

clear
echo -e "\n=== Stop Virtual Machine ===\n"

if [ ${#running_machines[@]} -eq 0 ]; then
    echo "No virtual machines are currently running."
    echo ""
    exit 0
fi

echo "Running machines (${#running_machines[@]}):"
echo ""

options=("${running_machines[@]}" "Stop ALL running machines")
PS3=$'\n'"Select a machine to stop (1-${#options[@]}): "$'\n'
COLUMNS=1

select choice in "${options[@]}"; do
    if [ "$choice" = "Stop ALL running machines" ]; then
        echo ""
        for vm in "${running_machines[@]}"; do
            echo "Stopping $vm..."
            (cd "$SCRIPT_DIR/$vm" && vagrant destroy -f)
        done
        echo -e "\nAll running machines stopped."
        break
    elif [ -n "$choice" ]; then
        echo -e "\nStopping $choice..."
        (cd "$SCRIPT_DIR/$choice" && vagrant destroy -f)
        echo -e "\n$choice stopped."
        break
    else
        echo "Invalid selection."
    fi
done