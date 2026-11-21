# =================================================================================================== #
# DEFAULT CONFIGURATION
# =================================================================================================== #

# UPDATE AND ANSIBLE
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

# SET HOSTNAMES
sudo hostnamectl set-hostname controlnode
echo "10.0.1.10 controlnode" | sudo tee -a /etc/hosts
echo "10.0.1.11 managednode" | sudo tee -a /etc/hosts

# =================================================================================================== #
# INVENTORY CONFIGURATION
# =================================================================================================== #

# SET STATIC IP ADDRESS FOR VIRTUAL MACHINE CLIENT
cat <<EOF | sudo tee /etc/ansible/hosts
[virtualmachines]
10.0.1.11
EOF

# VERIFY
# ansible all --list-hosts

# =================================================================================================== #
# SSH CONFIGURATION
# =================================================================================================== #

# GENERATE NEW KEYPAIR
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# COPY PUBLIC KEY TO CLIENT
# cat ~/.ssh/id_rsa.pub

# PING CLIENTS
# ansible all -m ping

# =================================================================================================== #
# CREATE INVENTORY
# =================================================================================================== #

# CREATE INVENTORY FILE
sudo touch ~/inventory.yaml
sudo chmod 644 ~/inventory.yaml
sudo chown user:user ~/inventory.yaml

# CONFIGURATION FOR INVENTORY
cat <<EOF | sudo tee ~/inventory.yaml
environment:
  hosts:
    vm01:
      ansible_host: "10.0.1.11"
EOF

# TO ADD MORE
#    vm01:
#      ansible_host: "10.0.1.11"
#    vm02:
#      ansible_host: "10.0.1.12"
#    ...

# VERIFY INVENTORY
# ansible-inventory -i inventory.yaml --list

# PING THE GROUP 
# ansible environment -m ping -i inventory.yaml

# =================================================================================================== #
# AD-HOC COMMANDS
# =================================================================================================== #

# CHECK DISK USAGE OF MACHINES
# ansible environment -a "df -h" -i inventory.yaml 

# TRANSFER A FILE TO ALL MACHINES
# ansible environment -m ansible.builtin.copy -a "src=/etc/hosts dest=/tmp/hosts" -i inventory.yaml

# CREATE DIRECTORIES ON ALL MACHINES
# ansible environment -m ansible.builtin.file -a "dest=/home/user/hello mode=755 owner=user group=user state=directory"

# SHELL COMMANDS LIKE ECHO
# ansible environment -m ansible.builtin.shell -a “echo ‘hello’”

# SHELL COMMAND TO CREATE A FILE WITH CONTENT
# ansible environment -m ansible.builtin.shell -a "echo 'hello' > ~/file.txt" -i inventory.yaml

# =================================================================================================== #
# PLAYBOOK CONFIGURATION
# =================================================================================================== #

# CREATE PLAYBOOK FILE
sudo touch ~/playbook.yaml
sudo chmod 644 ~/playbook.yaml
sudo chown user:user ~/playbook.yaml

# CONFIGURATION FOR PLAYBOOK
cat <<EOF | sudo tee ~/playbook.yaml
---
- name: Playbook
  hosts: environment
  tasks:
    - name: Ping VMs
      ansible.builtin.ping:
    - name: Print Message
      ansible.builtin.debug:
        msg: Hello Environment
...
EOF

# RUN PLAYBOOK
# ansible-playbook -i ~/inventory.yaml ~/playbook.yaml

# CHECK FOR SYNTAX ERRORS
# ansible-playbook ~/playbook.yaml --syntax-check -i ~/inventory.yaml