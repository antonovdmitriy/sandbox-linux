# sandbox-linux

[![GitHub Super-Linter](https://github.com/antonovdmitriy/sandbox-linux/workflows/Lint%20Code%20Base/badge.svg)](https://github.com/marketplace/actions/super-linter)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/0348b8406f90416eb5baf97a147ea7d8)](https://app.codacy.com/gh/antonovdmitriy/sandbox-linux/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

## Overview

The `sandbox-linux` project was designed to address a common problem many developers face when transitioning to a new computer: setting up their development environment. The project consists of a collection of scripts aimed to automate the process of configuring a development environment for different programming languages, specifically Java and Scala.

The primary purpose of `sandbox-linux` is to create a seamless, repeatable setup process for developers. Whether you're migrating to a new machine or simply looking to recreate your preferred work environment, these scripts streamline the process and ensure consistency across different systems.

While this project is primarily utilized for configuring a virtual Ubuntu machine, its flexibility allows for broader use cases. The scripts can be easily customized to meet your unique needs and can even be run on a native Linux system without the need for a virtual machine. This adaptability enables developers to quickly and efficiently set up their development environment, regardless of their specific circumstances.

By leveraging `sandbox-linux`, developers can save valuable time and focus more on coding and less on the intricacies of environment setup.

## Structure

This repository contains a set of scripts and Ansible playbooks that automate the process of setting up a development environment on an Ubuntu system. Here's an overview of the key components:

- `start_ubuntu.sh`: This is the primary script you'll run to set up your development environment. It configures the Ubuntu environment based on the provided arguments.

- `sudo-actions.sh`: This helper script prepares the environment for the Ansible playbooks. It installs Ansible and then triggers the execution of the appropriate playbook based on the arguments passed to it.

- `roles/`: This directory contains Ansible roles, each of which carries out a specific task or set of tasks in the setup process.

    - `environment_setup`: This role creates the main development user, installs specified packages, adds the user to the Docker group, starts the Docker daemon, and installs programs from the Snap repository.

    - `intelij_idea_setup`: This role installs the community version of IntelliJ IDEA and any specified plugins.

    - `git_setup`: This role configures Git, retrieves keys for accessing the Git repository from an Ansible vault, and clones the specified repositories.

    - `oracle_sql_developer_setup`: This role installs Oracle SQL Developer and configures the font size. It's included as a demonstration and not intended for commercial use. The distributive is downloaded from an AWS S3 bucket.

    - `vmware_specific_setup`: This helper role is used when running the setup in a VMware virtual machine.

- `start_playbook_java.yml` and `start_playbook_scala.yml`: These are Ansible playbooks that are used to configure Java and Scala development environments, respectively.

By separating these tasks into distinct roles and playbooks, the repository provides a flexible and modular approach to setting up a development environment.

## How to configure

The setup scripts make use of secrets stored in an Ansible vault file. This secure file is used to store sensitive information needed for the scripts to operate, such as certificates for accessing Git repositories and credentials for accessing external storage systems such as AWS S3. Here's what you need to know about the keys used:

- `github_private_key`: This is the private key used to authenticate with your GitHub repository. It enables the script to securely clone your repositories.

- `github_public_key`: This is the public key that pairs with your private key for GitHub repository a-ccess. It's used to authenticate your identity when the scripts interact with your repositories.

- `github_password_from_key`: If your private key is passphrase protected, provide that passphrase here to allow the scripts to unlock the key and use it for repository access.

- `aws_access_key_id`: This is your AWS access key ID. It's used to authenticate with AWS services, specifically to download distributives from your S3 bucket that are not available for installation from package repositories or snap.

- `aws_secret_access_key`: This is your AWS secret access key, which pairs with the `aws_access_key_id` to authenticate your AWS account.

Remember to keep your Ansible vault file secure, as it contains sensitive information. The file should be kept out of version control systems and access should be restricted to those who need it.

For details how to work with ansible vault please see Ansible docs or [this](https://github.com/antonovdmitriy/it-notes/blob/master/ansible/ansible.md#ansible-vault---%D1%81%D1%80%D0%B5%D0%B4%D1%81%D1%82%D0%B2%D0%BE-%D0%B4%D0%BB%D1%8F-%D1%85%D1%80%D0%B0%D0%BD%D0%B5%D0%BD%D0%B8%D1%8F-%D1%81%D0%B5%D0%BA%D1%80%D0%B5%D1%82%D0%BE%D0%B2)

## How to launch

Here's what you need to know about the command-line arguments:

```sh
./start-ubuntu.sh [options]
```

The options are as follows:

- `-h` or `--help` : Display the help text.
- `-e` or `--environment` : Specify the development environment to configure. The possible values are `java` and `scala`. The default is `java`.
- `-s` or `--secrets` : Provide the path to the secrets file. The default is `/mnt/hgfs/secrets/secret.yml`.
- `-v` or `--verbose` : Enable verbose output (-vv) in Ansible.

You can use the `--` option to signify the end of command options. Any arguments after this will not be interpreted as options.

Here's an example of how you can launch the script for a Java development environment:

```sh
sudo ./start-ubuntu.sh -e java
```

And for a Scala development environment:

```sh
sudo ./start-ubuntu.sh -e scala
```

If you want to enable verbose output in Ansible, add the `-v` option:

```sh
sudo ./start-ubuntu.sh -e java -v
```

At the end of the script's execution, it will display the total execution time in seconds.