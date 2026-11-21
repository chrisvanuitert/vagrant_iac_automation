#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIT_PROJECTS_DIR="/ssd/git"

cancel() {
    echo -e "\n\nCancelled."
    exit 130
}
trap cancel INT TERM

unset NIC2_ENABLED NIC3_INTNET_ENABLED NIC4_BRIDGED_ENABLED SHARED_FOLDER_ENABLED PROJECT_DIR
running_vms="$(VBoxManage list runningvms 2>/dev/null || true)"

vm_options=()
running_list=()
for i in 1 2 3; do
    if echo "$running_vms" | grep -q "\"virtualmachine${i}\""; then
        vm_options+=("virtual_machine_${i}  [RUNNING]")
        running_list+=("virtual_machine_${i}")
    else
        vm_options+=("virtual_machine_${i}  [stopped]")
    fi
done

clear
echo -e "\n=== Start Virtual Machine ===\n"
if [ ${#running_list[@]} -gt 0 ]; then
    echo "Currently running: ${running_list[*]}"
else
    echo "Currently running: none"
fi
echo ""

# 1. Select virtual machine
PS3=$'\n'"Select a machine (1-3): "$'\n'
COLUMNS=1

select choice in "${vm_options[@]}"; do
    if [[ "$REPLY" =~ ^[1-3]$ ]]; then
        VM_NUM="$REPLY"
        VM_DIR="$SCRIPT_DIR/virtual_machine_${VM_NUM}"
        break
    else
        echo "Invalid selection."
    fi
done
[ -z "$VM_NUM" ] && cancel

# 2. Select network mode
clear
echo -e "\n=== Network Mode (virtual_machine_${VM_NUM}) ===\n"
PS3=$'\n'"Select network type (1-3): "$'\n'

select net_mode in "Local (Host-only)" "Internal (Guest-to-Guest)" "Bridged (Host network)"; do
    case "$REPLY" in
        1)
            export NIC2_ENABLED=1
            NET_LABEL="Local"
            break
            ;;
        2)
            export NIC3_INTNET_ENABLED=1
            NET_LABEL="Internal"
            break
            ;;
        3)
            export NIC4_BRIDGED_ENABLED=1
            NET_LABEL="Bridged"
            break
            ;;
        *)
            echo "Invalid selection."
            ;;
    esac
done
[ -z "$NET_LABEL" ] && cancel

# 3. Select sandbox or project mode
clear
echo -e "\n=== Environment Mode (virtual_machine_${VM_NUM} | ${NET_LABEL}) ===\n"
PS3=$'\n'"Select environment type (1-2): "$'\n'

select env_mode in "Sandbox (no shared folder)" "Project (mount Git folder)"; do
    case "$REPLY" in
        1)
            ENV_LABEL="Sandbox"
            break
            ;;
        2)
            export SHARED_FOLDER_ENABLED=1
            clear
            echo -e "\n=== Select Git Project (${GIT_PROJECTS_DIR}) ===\n"
            mapfile -t projects < <(basename -a "$GIT_PROJECTS_DIR"/*/)
            PS3=$'\n'"Select a project (1-${#projects[@]}): "$'\n'

            select project in "${projects[@]}"; do
                if [ -n "$project" ]; then
                    export PROJECT_DIR="$GIT_PROJECTS_DIR/$project"
                    ENV_LABEL="Project ($project)"
                    break
                else
                    echo "Invalid selection."
                fi
            done
            break
            ;;
        *)
            echo "Invalid selection."
            ;;
    esac
done
[ -z "$ENV_LABEL" ] && cancel

echo -e "\nLaunching virtual_machine_${VM_NUM} | Network: ${NET_LABEL} | Mode: ${ENV_LABEL}\n"

cd "$VM_DIR" || exit 1
clear && vagrant destroy -f
clear && vagrant up && {
    trap - INT TERM
    clear && vagrant ssh
}