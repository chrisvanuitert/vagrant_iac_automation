# 📖 Official Vagrantfile Reference Documentation

Vagrant is a tool for building and managing virtual machine environments in a single workflow. The `Vagrantfile` describes the type of machine required, how to configure/provision it, and how to set up networking.

Below is the official reference guide for configuring a `Vagrantfile` (Configuration version 2).

---

## 📂 1. Vagrantfile Load Order & Merging

Vagrant loads and merges multiple Vagrantfiles in the following order:

1. **Box Vagrantfile**: The Vagrantfile packaged inside the box image.
2. **User Vagrantfile**: The global config located in the user's home directory (`~/.vagrant.d/Vagrantfile`).
3. **Project Vagrantfile**: The local Vagrantfile in the project root directory.
4. **Multi-machine Definitions**: Configurations defined specifically for named VMs inside the local Vagrantfile.

> [!NOTE]
> Settings specified later in the load order override or append to settings loaded earlier.

---

## 💻 2. Machine Settings (`config.vm`)

These parameters configure guest operating system properties and resources:

- **`config.vm.box`**: The box image to boot (must match a box installed locally or found on Vagrant Cloud).
- **`config.vm.box_url`**: URL(s) to download the box if it is not already installed.
- **`config.vm.box_version`**: Version constraint for the box (e.g., `">= 1.0.0"`, `"~> 2.1"`).
- **`config.vm.box_check_update`**: Automatically check for box updates during `vagrant up` (default: `true`).
- **`config.vm.hostname`**: The guest OS hostname.
- **`config.vm.boot_timeout`**: Time in seconds to wait for the machine to boot before failing (default: `300`).
- **`config.vm.communicator`**: Communicator type to connect to guest (`"ssh"`, `"winrm"`, or `"winssh"`).
- **`config.vm.graceful_halt_timeout`**: Time in seconds Vagrant waits when halting before forcing power off.
- **`config.vm.guest`**: The guest OS type (e.g., `:ubuntu`, `:debian`, `:redhat`, `:windows`).
- **`config.vm.post_up_message`**: Message displayed in terminal after running `vagrant up`.
- **`config.vm.disk`**: Configure extra disk resources (available in Vagrant 2.2.14+).
  - *Example:* `vm.disk :disk, size: "50GB", primary: true`

---

## 🔑 3. SSH Configuration (`config.ssh`)

Defines how Vagrant connects to the guest machine:

- **`config.ssh.username`**: Username used to log in via SSH (default: `"vagrant"`).
- **`config.ssh.password`**: Password used for SSH (not recommended, use keys).
- **`config.ssh.host`**: Host IP to connect to (default: localhost / NAT interface).
- **`config.ssh.port`**: Port to connect to (default: `2222`, auto-forwarded).
- **`config.ssh.guest_port`**: Port on the guest being forwarded (default: `22`).
- **`config.ssh.private_key_path`**: Path to private key file for SSH authentication.
- **`config.ssh.forward_agent`**: Enable agent forwarding over the SSH connection (default: `false`).
- **`config.ssh.forward_x11`**: Enable X11 forwarding over the SSH connection (default: `false`).
- **`config.ssh.insert_key`**: Insert a new unique SSH key on first boot (default: `true`).

---

## 🌐 4. Networking (`config.vm.network`)

### A. Port Forwarding
Maps a port on the host machine to a port on the guest VM.
- **Syntax:** `config.vm.network "forwarded_port", guest: <guest_port>, host: <host_port>`
- **Options:**
  - `host_ip`: Bind the host port to a specific IP (default: `127.0.0.1`).
  - `guest_ip`: Forward to a specific guest IP if guest has multiple.
  - `protocol`: `"tcp"` or `"udp"` (default: `"tcp"`).
  - `auto_correct`: If `true`, Vagrant corrects port collisions automatically (default: `false`).

### B. Private Network (Host-Only)
Allows host-to-guest and guest-to-guest communication, isolated from the outside network.
- **Syntax:** `config.vm.network "private_network", ip: "192.168.56.10"`
- **Options:**
  - `ip`: Static IP for the adapter.
  - `type`: Set to `"dhcp"` to let VirtualBox/DHCP server assign the IP.

### C. Public Network (Bridged)
Bridges the VM onto the same physical network as the host, allowing it to lease its own IP from the local router.
- **Syntax:** `config.vm.network "public_network", bridge: "en0: Wi-Fi"`
- **Options:**
  - `bridge`: Host interface device name.
  - `use_dhcp_assigned_default_route`: Set to `true` to override the default gateway.

---

## 💾 5. Synced Folders (`config.vm.synced_folder`)

Shared host directories mounted directly inside the guest VM.
- **Syntax:** `config.vm.synced_folder "<host_path>", "<guest_path>"`
- **Options:**
  - `disabled`: Set to `true` to disable a folder configuration.
  - `group`: The group owner of the guest files (default: `"vagrant"`).
  - `owner`: The user owner of the guest files (default: `"vagrant"`).
  - `type`: Sync mechanism to use: `"nfs"`, `"rsync"`, `"smb"`, or `"virtualbox"` (default).
  - `mount_options`: Special flags passed to the mount engine.

---

## ⚙️ 6. Provisioning (`config.vm.provision`)

Automated installation and configuration of packages after VM boot.
- **Syntax:** `config.vm.provision "<type>" do |s| ... end`

### Types:
1. **Shell** (run bash/script commands):
   - `path`: path to host script file.
   - `inline`: bash commands string.
   - `args`: arguments to pass to the script.
   - `privileged`: runs script as root (default: `true`).
2. **File** (copy files from host to guest):
   - `source`: host file path.
   - `destination`: guest destination path.
3. **Configuration Management**:
   - Supports: Ansible, Chef, Puppet, Docker, Salt.

---

## 🏗️ 7. Providers (`config.vm.provider`)

Customize hypervisor-specific attributes.
- **Syntax:**
  ```ruby
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
    vb.cpus = 2
    vb.name = "my-vm"
    vb.gui = true
    vb.customize ["modifyvm", :id, "--vram", "16"]
  end
  ```

### Commonly Used Providers:
- `"virtualbox"`
- `"vmware_desktop"`
- `"docker"`
- `"hyperv"`