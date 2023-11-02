#!/bin/bash

if ! command -v nmap &> /dev/null; then
  echo "Nmap is not installed. Please install it to run this script."
  exit 1

fi


read -p "Enter IP range (Example:192.168.x.x):  " IP_RANGE
read -p "Enter SSH port (Default is 22):  " SSH_PORT

IP_RANGE=${IP_RANGE:-192.168.1.1-254}
SSH_PORT=${SSH_PORT:-22}

nmap -oG - -p $SSH_PORT $IP_RANGE | grep "$SSH_PORT/open" > ssh_hosts.txt

if [ -s ssh_hosts.txt ]; then
  echo "SSH Key Management needed for the following hosts:"
  cat ssh_hosts.txt
else
  echo "No hosts with SSH open Found."
fi

nmap -sL $IP_RANGE | grep "Nmap scan report for" | awk '{print $5}' > hostnames.txt

if [ -s hostnames.txt ]; then
  echo "Resolved hostnames:"
  cat hostnames.txt
fi

nmap -sV -p $SSH_PORT -iL ssh_hosts.txt -oN service_versions.txt

rm ssh_hosts.txt hostnames.txt

