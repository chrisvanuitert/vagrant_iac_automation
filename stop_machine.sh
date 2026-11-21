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

VBOX_DIR="$(VBoxManage list systemproperties 2>/dev/null | awk -F': *' '/Default machine folder/{print $2}')"

destroy_vm() {
    local vm="$1"
    local num="${vm##*_}"
    echo "Stopping $vm..."
    (cd "$SCRIPT_DIR/$vm" && vagrant destroy -f)
    if [ -n "$VBOX_DIR" ] && ! VBoxManage list vms 2>/dev/null | grep -q "\"virtualmachine${num}\""; then
        rm -rf "$VBOX_DIR/vagrant_machines/virtualmachine${num}"
    fi
}

select choice in "${options[@]}"; do
    if [ "$choice" = "Stop ALL running machines" ]; then
        echo ""
        for vm in "${running_machines[@]}"; do
            destroy_vm "$vm"
        done
        echo -e "\nAll running machines stopped."
        break
    elif [ -n "$choice" ]; then
        echo ""
        destroy_vm "$choice"
        echo -e "\n$choice stopped."
        break
    else
        echo "Invalid selection."
    fi
done