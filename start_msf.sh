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

mkdir -p "$PWD/msf"

echo "[+] Run a metasploit Docker container..."
docker run -ti --network host -v $PWD/msf:/root/ parrotsec/metasploit
echo "[*] welcome to instant lab environment with parrotsec/metasploit container!"
sudo usermod -aG docker $USER
newgrp docker