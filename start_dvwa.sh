#!/usr/bin/env bash
set -euo pipefail

echo "[+] Installing docker..."
if ! command -v docker >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y docker.io
  sudo systemctl enable --now docker
  echo "[*] docker installed and started"
else
  echo "[*] docker is already installed."
fi

mkdir -p "$DVWA_DIR"

echo "[+] Starting DVWA container..."
# docker run --rm -it -p 80:80 vulnerables/web-dvwa
docker run -d -p 8888:80 vulnerables/web-dvwa

# docker pull sagikazarmark/dvwa
# # docker run --rm -it -p 8080:80 sagikazarmark/dvwa
# docker run -d --name dvwa -p 8080:80 sagikazarmark/dvwa
echo "[*] DVWA container is running. Access it at http://localhost:8888"
# echo "[*] DVWA container is running. Access it at http://localhost:8080"
echo "[*] welcome to instant lab environment with DVWA container!"

sudo usermod -aG docker $USER
newgrp docker