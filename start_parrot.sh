#!/usr/bin/env bash
set -euo pipefail

echo "[+] Update and upgrade the OS"
sudo parrot-upgrade

echo "[+] Installing docker..."
if ! command -v docker >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y docker.io
  sudo systemctl enable --now docker
  echo "[*] docker installed and started"
else
  echo "[*] docker is already installed."
fi

mkdir -p "$PWD/work" "$PWD/msf"
echo "[+] Updating and installing packages in Parrot container..."
docker run -ti --network host -v $PWD/work:/work parrotsec/security

  apt update
  apt install -y \
    python3 \
    python3-pip \
    nano \
    wget \
    curl \
    hashcat \
    net-tools \
    john \
    tshark \
    nikto \
    hydra \
    gobuster \
    sqlmap \
    tcpdump \
    git \
    metasploit-framework \
    dnsmap \
    recon-ng \
    sslscan \
    && apt clean

sudo usermod -aG docker $USER
newgrp docker
echo "[*] Your parrot container is ready."
echo "[*] welcome to instant lab environment with parrotsec/security container!"
