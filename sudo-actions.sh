#!/bin/bash

# Define log levels
INFO="\033[1;34mINFO:\033[0m"
WARN="\033[1;33mWARNING:\033[0m"
ERROR="\033[1;31mERROR:\033[0m"

if [ -z "$1" ]; then echo -e "$ERROR First argument (playbook path) is empty" >&2; exit 1; fi
if [ ! -f "$1" ]; then echo -e "$ERROR Playbook $1 does not exist" >&2; exit 2; fi
if [ -z "$2" ]; then echo -e "$ERROR Second argument (secrets path) is empty" >&2; exit 3; fi
if [ ! -f "$2" ]; then echo -e "$ERROR Secrets file $2 does not exist" >&2; exit 4; fi

echo -e "$INFO Creating technical ansible user..."
useradd  -m ansible -s /bin/bash > /dev/null

echo -e "$INFO Granting ansible user get sudo without password..."
echo "ansible ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers > /dev/null

echo -e "$INFO Updating repositories and system packages..."
apt update > /dev/null
apt -y upgrade > /dev/null

echo -e "$INFO Cleaning old packages and journal..."
apt -y autoremove > /dev/null
apt -y autoclean > /dev/null
journalctl --vacuum-time=1d > /dev/null

echo -e "$INFO Installing ansible..."
apt -y install ansible > /dev/null

echo -e "$INFO Configuring ansible..."
tee -a >> /home/ansible/ansible.cfg << EOF
[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False
EOF

echo -e "$INFO Copying start playbook to ansible home directory..."
cp "$1" /home/ansible/start_playbook.yml
chown ansible:ansible /home/ansible/start_playbook.yml

echo -e "$INFO Copying roles directory to ansible home directory..."
cp -R ./roles/ /home/ansible/roles
chown -R ansible:ansible /home/ansible/roles

echo -e "$INFO Running start playbook as ansible user..."
sudo -u ansible -H sh -c "cd ~; ansible-playbook start_playbook.yml $3 -e @$2 --ask-vault-pass"

echo -e "$INFO Deleting technical ansible user..."
userdel -r ansible
sed -i '/ansible/d' /etc/sudoers
