#!/bin/bash

## create ansible user

useradd  -m ansible -s /bin/bash
echo "ansible ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
su ansible
echo $SUER