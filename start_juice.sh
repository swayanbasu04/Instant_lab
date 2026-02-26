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

# Add current user to docker group if not already a member
if ! groups "$USER" | grep -qw docker; then
  sudo usermod -aG docker "$USER"
  echo "[*] added $USER to docker group — you may need to log out/in for this to take effect"
else
  echo "[*] $USER is already in docker group"
fi

echo "[+] Starting juice-shop container..."
# Use a consistent image and run detached with a name so you can manage it easily.
IMAGE="bkimminich/juice-shop:latest"
CONTAINER_NAME="juice-shop"
HOST_PORT=3000
CONTAINER_PORT=3000

# Pull latest image to avoid running an outdated image
docker pull "$IMAGE"
echo "[*] pulled latest juice-shop image: $IMAGE"
# If a container with the same name exists, remove it (stop + rm)
if docker ps -a --format '{{.Names}}' | grep -qw "$CONTAINER_NAME"; then
  echo "[*] removing existing container named $CONTAINER_NAME"
  docker rm -f "$CONTAINER_NAME"
fi

# Run detached so the script finishes; map port and restart policy
echo "[*] running juice-shop container named $CONTAINER_NAME on port $HOST_PORT"
docker run -d --name "$CONTAINER_NAME" -p "${HOST_PORT}:${CONTAINER_PORT}" --restart unless-stopped "$IMAGE"

echo "[*] Juice-Shop container is running. Access it at http://localhost:${HOST_PORT} or 0.0.0.0:3000"
echo "[*] welcome to instant lab environment with Juice-Shop container!"
# Maintainer: swayan basu <github.com/swayanbasu>