#!/bin/bash

## create technical ansible user
useradd  -m ansible -s /bin/bash
## grant ansible user get sudo without password
echo "ansible ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
# ## update repositories and system packages
# add rights to read from shared folder in virtual box
# usermod -aG vboxsf ansible
apt update
apt -y upgrade
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
cp ./start_playbook.yml /home/ansible/start_playbook.yml
## change owner to ansible
chown ansible:ansible /home/ansible/start_playbook.yml
## run start playbok as ansible user
sudo -u ansible -H sh -c "cd ~; ansible-playbook start_playbook.yml -vv -e @/mnt/hgfs/secrets/secret.yml --ask-vault-pass"
## delete technocal ansible user
userdel -r ansible
sed -i '/ansible/d' /etc/sudoers