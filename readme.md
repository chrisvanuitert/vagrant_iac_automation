# Vagrantfile Automation (IaC)

A premium infrastructure-as-code (IaC) automation framework designed to streamline guest VM builds, lifecycle management, package provisioning, and dynamic volume mounting on Linux hosts.

---

## Repository Layout

```
.
├── readme.md                    # This overview guide
├── vagrant_documentation.md     # Official Vagrant configuration reference guide
├── vagrant_installation.md      # Vagrant installation and removal guides
├── vagrantfile_example          # Reference IaC configuration blueprint
├── vagrantfile_empty            # Clean template to start new environments
│
├── host_scripts/                # Host-level lifecycle control scripts
│   ├── project_automation.sh    # Dynamic VM project mounting and connection manager
│   ├── start_vagrant_machine.sh # Scaffolds a clean environment and connects
│   ├── stop_vagrant_machine.sh  # Halts and destroys the target environment
│   ├── shutdown_vbox.sh         # ACPI power down tool for all active VirtualBox VMs
│   └── shutdown_docker.sh       # Clean stopper for running docker containers
│
└── vm_scripts/                  # Guest VM provisioning scripts
    ├── init_apt.sh              # Updates package lists
    ├── init_motd.sh             # Configures Message of the Day banner
    ├── init_ntp.sh              # Synchronizes network system clocks
    ├── install_git.sh           # Installs git
    ├── install_docker_ubuntu.sh # Configures docker and container runtimes
    ├── install_fastfetch_ubuntu.sh # Installs fastfetch utility
    ├── install_aws_cli.sh       # Installs AWS command-line interface
    └── install_azure_cli.sh     # Installs Azure command-line interface
```

---

## Blueprints & Scripts Comparison

### Configuration Blueprints
- **`vagrantfile_empty`**: A minimal, bare-bones configuration template. It provides the basic structure to scaffold a clean environment from scratch.
- **`vagrantfile_example`**: A fully configured, ready-to-run **complete sandbox**. It defines network profiles, system resources, storage capacities, and contains pre-linked shell scripts to boot into a fully functioning environment.

### Host Scripts vs. VM Scripts
- **`host_scripts/` (Host Execution)**: Run locally on the host computer. They manage VM lifecycle states, clean up VirtualBox processes/Docker containers, and dynamically select which workspace project to mount into the guest VM.
- **`vm_scripts/` (Guest Execution - Reference Only)**: Run inside the virtual machine guest OS during the VM provisioning phase. They are included in this repository **just for reference** to show examples of automated software setups.

---

## Host Automation Scripts (`host_scripts/`)

### 1. Dynamic Mounting Selector (`project_automation.sh`)
Prompts the user to choose an active development project folder from their workspace directory and mounts it directly into the VM:
- Define `VAGRANT_FOLDER` and `PROJECTS_FOLDER` at the top of the script.
- The script matches existing projects, dynamically updates the `Vagrantfile` synced folder source path, and redeploys the environment (`vagrant up && vagrant ssh`).

### 2. Standalone Bootstrapper (`start_vagrant_machine.sh`)
Destroys any existing VM in the defined directory path, spins up a fresh sandbox, and initiates an interactive SSH terminal.

### 3. Standalone Teardown (`stop_vagrant_machine.sh`)
Performs a forced destruction (`vagrant destroy -f`) of the environment defined in the path variable to instantly free up disk space and system memory.

### 4. Global Hypervisor Shutdown (`shutdown_vbox.sh` & `shutdown_docker.sh`)
- `shutdown_vbox.sh`: Safely commands all running VirtualBox VMs to shut down using ACPI signals. If a machine fails to shut down after 20 seconds, it issues a forced power-off.
- `shutdown_docker.sh`: Gracefully stops all active containers running on the host system.

---

## VM Provisioning (`vm_scripts/`)

Provisioning files are referenced directly in your `Vagrantfile`'s provision section. They boot sequentially as root (`sudo`) during initial creation or when running `vagrant provision`. They handle system updates, developer configurations, shell profiles, and command-line interfaces.

## Authors

- [@chrisvanuitert](https://www.github.com/chrisvanuitert)