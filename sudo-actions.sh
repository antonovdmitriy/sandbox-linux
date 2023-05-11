#!/bin/bash

if [ -z "$1" ]; then echo "First argument (playbook path) is empty" >&2; exit 1; fi
if [ ! -f "$1" ]; then echo "Playbook $1 does not exist" >&2; exit 2; fi
if [ -z "$2" ]; then echo "Second argument (secrets path) is empty" >&2; exit 3; fi
if [ ! -f "$2" ]; then echo "Secrets file $2 does not exist" >&2; exit 4; fi

# create technical ansible user
useradd  -m ansible -s /bin/bash
# grant ansible user get sudo without password
echo "ansible ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
# update repositories and system packages
apt update
apt -y upgrade
# clean old packages and journal
apt -y autoremove
apt -y autoclean
journalctl --vacuum-time=1d
## install ansible
apt -y install ansible
## put default ansible config to ansible home directory
tee -a >> /home/ansible/ansible.cfg << EOF
[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False
EOF
change gnome terminal font size

# copy start playbook from current directory to ansible home directory
cp "$1" /home/ansible/start_playbook.yml
## change owner to ansible
chown ansible:ansible /home/ansible/start_playbook.yml
# copy roles directory from source directory to ansible home directory
cp -R ./roles/ /home/ansible/roles
# change owner to ansible for roles directory and its contents
chown -R ansible:ansible /home/ansible/roles
## run start playbok as ansible user
sudo -u ansible -H sh -c "cd ~; ansible-playbook start_playbook.yml -vv -e @$2 --ask-vault-pass"
## delete technical ansible user
userdel -r ansible
sed -i '/ansible/d' /etc/sudoers