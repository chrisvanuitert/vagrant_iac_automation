# Installing Vagrant

This guide details how to install and uninstall HashiCorp Vagrant on popular distributions and operating systems.

---

## Linux Distributions

### Ubuntu / Debian (APT)
```bash
# Add HashiCorp GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Install Vagrant
sudo apt update && sudo apt install vagrant
```

### CentOS / RHEL / Fedora (DNF/YUM)
```bash
# Add repository
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

# Install Vagrant
sudo dnf install vagrant
```

### Arch Linux (Pacman)
```bash
sudo pacman -S vagrant
```

---

## macOS

Using Homebrew:
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/vagrant
```

---

## Windows

Using winget:
```cmd
winget install HashiCorp.Vagrant
```

---

## Removing Vagrant

### Ubuntu / Debian
```bash
sudo apt purge vagrant
sudo rm /etc/apt/sources.list.d/hashicorp.list
sudo rm /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

### CentOS / RHEL / Fedora
```bash
sudo dnf remove vagrant
sudo rm /etc/yum.repos.d/hashicorp.repo
```

### Arch Linux
```bash
sudo pacman -R vagrant
```

### macOS
```bash
brew uninstall hashicorp/tap/vagrant
```