#!/bin/bash

# File name
PROGNAME=$(basename "$0")
environment=java
java_playbook=./start_playbook_java.yml
scala_playbook=./start_playbook_scala.yml
secrets_file=/mnt/hgfs/secrets/secret.yml

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
	--)
		break
		;;
	-*)
		echo "Invalid option '$1'. Use --help to see the valid options" >&2
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
  echo 'wrong envinoment. see --help' >&2; exit 1
  ;;
esac

sudo ./sudo-actions.sh $playbook_to_start $secrets_file
