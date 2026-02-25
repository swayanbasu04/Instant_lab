#!/usr/bin/env bash
set -euo pipefail
#enable below line if you're already an parrot user
# echo "[+] Update and upgrade the OS"
# sudo parrot-upgrade

echo "[+] Installing docker..."
if ! command -v docker >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y docker.io
  sudo systemctl enable --now docker
  echo "[*] docker installed and started"
else
  echo "[*] docker is already installed."
fi
read -p "Do you want to install SOC tools in the container? (y/n) " install_soc_tools
if [[ "$install_soc_tools" =~ ^[Yy]$ ]]; then
  echo "[*] Executing soc_tools.sh in the container..."
  docker run -ti --network host -v $PWD/work:/work -v $PWD/soc_tools.sh:/soc_tools.sh parrotsec/security bash /soc_tools.sh --yes
else
  echo "[*] Skipping soc_tools.sh execution."
fi
mkdir -p "$PWD/work" "$PWD/msf"
echo "[+] Updating and installing packages in Parrot container..."
docker run -ti --network host -v $PWD/work:/work -v $PWD/soc_tools.sh:/soc_tools.sh parrotsec/security
echo "[*] Your parrot container is ready."
echo "[*] welcome to instant lab environment with parrotsec/security container!"
