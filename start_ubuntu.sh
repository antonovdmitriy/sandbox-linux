#!/bin/bash

# Start timer
start=$(date +%s)

# Define log levels
INFO="\033[1;34mINFO:\033[0m"
WARN="\033[1;33mWARNING:\033[0m"
ERROR="\033[1;31mERROR:\033[0m"

# File name
PROGNAME=$(basename "$0")
# Default values
environment=java
java_playbook=./start_playbook_java.yml
scala_playbook=./start_playbook_scala.yml
secrets_file=/mnt/hgfs/secrets/secret.yml
verbose=""

usage() {
	echo "Script for prepare linux enviromment for development"
	echo
	echo "Usage: $PROGNAME -i <file> -o <file> [options]..."
	echo
	echo "Options:"
	echo
	echo "  -h, --help"
	echo "      This help text."
	echo
	echo "  -e <environemt>, --environment <environment>"
	echo "      Possible environment: java, scala. Java is default"
	echo
	echo "  -s <secrets>, --secrets <secrets>"
	echo "      Path to secrets file. Default is /mnt/hgfs/secrets/secret.yml"
	echo
	echo "  -v, --verbose"
	echo "      Enable verbose output (-vv) in Ansible."	
	echo
	echo "  --"
	echo "      Do not interpret any more arguments as options."
	echo
}

while [ "$#" -gt 0 ]
do
	case "$1" in
	-h|--help)
		usage
		exit 0
		;;
	-e|--environment)
		environment="$2"
		shift
		;;
	-s|--secrets)
		secrets_file="$2"
		shift
		;;
	-v|--verbose)
		verbose="-vv"
		;;		
	--)
		break
		;;
	-*)
		echo -e "$ERROR Invalid option '$1'. Use --help to see the valid options" >&2
		exit 1
		;;
	*)	;;
	esac
	shift
done

case $environment in
java)
  playbook_to_start=$java_playbook
  ;;
scala)
  playbook_to_start=$scala_playbook
  ;;
*)
  echo -e "$ERROR wrong environment. see --help" >&2; exit 1
  ;;
esac

echo -e "$INFO Starting sudo actions with playbook: $playbook_to_start and secrets file: $secrets_file"
sudo ./sudo-actions.sh $playbook_to_start $secrets_file $verbose

# End timer
end=$(date +%s)
runtime=$((end-start))

echo -e "$INFO Done. Execution time: $runtime seconds"
