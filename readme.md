# Vagrant IaC Automation

An Infrastructure-as-Code (IaC) automation framework for launching, networking, provisioning, and tearing down Ubuntu VirtualBox VMs via interactive Bash menus and environment-driven Vagrantfiles.

---

## Overview

Instead of maintaining separate Vagrantfiles for every network and project combination, this repository provides **three reusable virtual machine slots** (`virtual_machine_1`–`3`) dynamically configured at launch time via environment variables:

1. **Interactive Launcher (`start_machine.sh`):** Displays live running VM status via `VBoxManage`, lets you pick a VM slot (`1`–`3`), select a network mode (**Local**, **Internal**, or **Bridged**), and choose between an isolated **Sandbox** or mounting a local **Git project** into `/vagrant`.
2. **Interactive Teardown (`stop_machine.sh`):** Lists all currently running VMs and destroys either a single selected machine or all running machines at once.
3. **Self-Contained Provisioning (`shell_scripts/`):** Automatically updates APT, installs base utilities, syncs NTP (`Europe/Amsterdam`), configures a custom `fastfetch` MOTD, and installs Git, Docker CE, and Node.js 20 — plus optional installers and service/recon blueprints.

---

## Repository Layout

```text
.
├── readme.md                          # This guide
├── .gitignore                         # Ignores .vagrant/ state dirs, *.box, and console logs
├── start_machine.sh                   # Interactive VM launcher (machine, network, sandbox/project)
├── stop_machine.sh                    # Interactive VM stopper (single or all running VMs)
│
├── virtual_machine_1/
│   └── Vagrantfile                    # virtualmachine1 (Local IP: 192.168.1.10)
├── virtual_machine_2/
│   └── Vagrantfile                    # virtualmachine2 (Local IP: 192.168.1.11)
├── virtual_machine_3/
│   └── Vagrantfile                    # virtualmachine3 (Local IP: 192.168.1.12)
│
└── shell_scripts/
    ├── init/                          # Baseline VM setup (APT, basics, NTP, Fastfetch MOTD)
    ├── install/                       # Standalone tool installers (Docker, Node, AWS/Azure CLI, Ollama, OpenTofu, etc.)
    ├── clean/                         # APT and Docker cleanup utilities
    └── extra/                         # Optional service blueprints & networking/OSINT reference scripts
```

---

## Prerequisites

Ensure **VirtualBox** and **Vagrant** are installed on the host:

### Debian / Ubuntu
```bash
sudo apt update && sudo apt install -y virtualbox vagrant
```

### Fedora / RHEL
```bash
sudo dnf install -y VirtualBox vagrant
```

### Arch Linux
```bash
sudo pacman -S --noconfirm virtualbox vagrant
```

### Host Configuration (First-Time Setup)

1. Set `GIT_PROJECTS_DIR` at the top of `start_machine.sh` to your local Git repositories folder (default: `/ssd/git`).
2. Update `nic4_host_adapter` in `virtual_machine_1–3/Vagrantfile` if your host's physical network interface differs from `wlp0s20f3` (check with `ip a`).

---

## Usage

### Start a Virtual Machine

```bash
chmod +x start_machine.sh stop_machine.sh
./start_machine.sh
```

The launcher walks through three menus *(press `Ctrl+C` or `Ctrl+D` at any prompt to cancel cleanly)*:

1. **Select Machine (`1`–`3`):** Shows live `[RUNNING]` / `[stopped]` status for `virtual_machine_1`–`3`.
2. **Select Network Mode:**
   - **Local (Host-only):** Assigns a static host-only IP (`192.168.1.10`–`.12`) for host-to-guest communication.
   - **Internal (Guest-to-Guest):** Attaches the VM to the isolated VirtualBox internal network (`10.0.1.0`).
   - **Bridged (Host network):** Connects directly to your LAN via `nic4_host_adapter` with DHCP.
3. **Select Environment Mode:**
   - **Sandbox:** Disables all host shared folders for a clean, isolated environment.
   - **Project:** Lists folders inside `GIT_PROJECTS_DIR` and mounts the selected repository into `/vagrant`.

The script then recreates the selected VM (`vagrant destroy -f` → `vagrant up`) and drops you directly into an SSH session (`vagrant ssh`).

---

### Stop Virtual Machines

```bash
./stop_machine.sh
```

Displays all currently running VMs and lets you destroy an individual VM or select **Stop ALL running machines**.

---

## Technical Reference

### Virtual Machine Profiles

| Directory | VM / Hostname | Base Box | Resources | Local IP (NIC2) | Internal Net (NIC3) | Bridged Adapter (NIC4) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `virtual_machine_1/` | `virtualmachine1` | `ubuntu/jammy64` | 6 vCPU, 8 GB RAM, 100 GB | `192.168.1.10` | `10.0.1.0` | `wlp0s20f3` |
| `virtual_machine_2/` | `virtualmachine2` | `ubuntu/jammy64` | 6 vCPU, 8 GB RAM, 100 GB | `192.168.1.11` | `10.0.1.0` | `wlp0s20f3` |
| `virtual_machine_3/` | `virtualmachine3` | `ubuntu/jammy64` | 6 vCPU, 8 GB RAM, 100 GB | `192.168.1.12` | `10.0.1.0` | `wlp0s20f3` |

*(All VMs retain VirtualBox's default NAT adapter on NIC1 for Vagrant SSH).*

### Environment Variables

Toggle flags use Ruby truthiness in each `Vagrantfile` — **set** (`1`) enables the feature, **unset** disables it:

| Variable | Effect When Set |
| :--- | :--- |
| `NIC2_ENABLED` | Enables the host-only private network adapter with the VM's static IP. |
| `NIC3_INTNET_ENABLED` | Enables the VirtualBox internal network adapter (`10.0.1.0`). |
| `NIC4_BRIDGED_ENABLED` | Enables the bridged public network adapter on `nic4_host_adapter`. |
| `SHARED_FOLDER_ENABLED` | Enables mounting `PROJECT_DIR` to `/vagrant` (default share `.` is always disabled). |
| `PROJECT_DIR` | Absolute host path of the Git project to mount into `/vagrant`. |

### Default Provisioning Pipeline

Each VM executes the following scripts sequentially from `../shell_scripts/` during `vagrant up`:

1. `init/init_apt.sh` — Non-interactive APT repository update and package upgrade
2. `init/init_basics.sh` — Installs `ca-certificates`, `curl`, `gpg`, `tree`, and `unzip`
3. `init/init_ntp.sh` — Installs `ntp`, sets timezone to `Europe/Amsterdam`, and syncs system clock
4. `init/init_motd.sh` — Replaces default MOTD with `fastfetch`, disables MOTD news, and hides SSH last-login banners
5. `install/install_fastfetch_ubuntu.sh` — Adds the `fastfetch` PPA and installs `fastfetch`
6. `install/install_git.sh` — Installs `git`
7. `install/install_docker_ubuntu.sh` — Installs Docker CE, Buildx, and Compose plugin, configures DNS, and adds `vagrant` to the `docker` group
8. `install/install_node.sh` — Installs Node.js 20.x and `npm` via NodeSource
9. `clean/clean_apt.sh` — Upgrades, autoremoves unused packages, and cleans APT cache

Additional optional installers (`install_aws_cli.sh`, `install_azure_cli.sh`, `install_ollama.sh`, `install_opentofu.sh`, etc.) and reference blueprints are available under `shell_scripts/install/` and `shell_scripts/extra/`.

---

## Authors

- [@chrisvanuitert](https://www.github.com/chrisvanuitert)