#!/bin/bash

ls -l

if [ -z "$1" ]; then echo "$1" argument for playbook is empty >&2; exit 1; fi
if [ ! -f "$1" ]; then echo "$1" playbook does not exist >&2; exit 2; fi

## create technical ansible user
useradd  -m ansible -s /bin/bash
## grant ansible user get sudo without password
echo "ansible ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
# ## update repositories and system packages
# add rights to read from shared folder in virtual box
# usermod -aG vboxsf ansible
apt update
apt -y upgrade
apt autoremove
apt autoclean
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
## run start playbok as ansible user
sudo -u ansible -H sh -c "cd ~; ansible-playbook start_playbook.yml -vv -e @/mnt/hgfs/secrets/secret.yml --ask-vault-pass"
## delete technocal ansible user
userdel -r ansible
sed -i '/ansible/d' /etc/sudoers