#!/usr/bin/env bash
set -e
sudo parrot-upgrade
sudo apt update && sudo apt install -y docker.io
mkdir -p "$PWD/work" "$PWD/msf"
# Docker lab using Parrot enviroment
docker run --rm -ti --network host -v "$PWD/work":/work parrotsec/security
# install neccesary packages
apt install wget net-tools python3 python3-pip wget curl hashcat john hydra git dig nikto metasploit-framework zapproxy dnsmap recon-ng sslscan gobuster 
newgrp docker
# Run nmap (uncomment to use)
# docker run --rm -ti parrotsec/nmap options

# Run metasploit container with mounted msf dir (uncomment to use)
# docker run --rm -ti --network host -v $PWD/msf:/root/ parrotsec/metasploit
docker run --rm -d --name juice-shop -p 3000:3000 bkimminich/juice-shop

