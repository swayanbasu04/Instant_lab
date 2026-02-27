#!/usr/bin/env bash
set -euo pipefail
#uncomment below line if you're already an parrot user
#echo "[+] Update and upgrade the OS"
#sudo parrot-upgrade

echo "[+] Installing docker..."
if ! command -v docker >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y docker.io
  sudo systemctl enable --now docker
  echo "[*] docker installed and started"
else
  echo "[*] docker is already installed."
fi
exit 0
