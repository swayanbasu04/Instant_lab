
# echo "[+] Updating and installing packages in kali container..."
# # FROM kalilinux/kali-rolling:latest
# sudo apt update && apt install -y \
#     python3 \
# docker build -t rkali
# mkdir -p "$PWD/rkali"
# docker run --rm -it --network host -v $PWD/rkali:/rkali rkali bash
# # docker pull kalilinux/kali-rolling
# # docker run --tty --interactive kalilinux/kali-rolling
# # sudo apt update && sudo apt -y install kali-linux-headless

# sudo usermod -aG docker $USER
# newgrp docker

# # mkdir -p "$PWD/work"
# # docker run --rm -v "$PWD":/workdir -w /workdir -it kali-rolling



#!/usr/bin/env bash
set -euo pipefail

# Minimal, idempotent setup for building/running a Kali container image named "rkali".

USER_NAME="${SUDO_USER:-${USER}}"
WORKDIR="$PWD"
RKALI_DIR="$WORKDIR/rkali"
IMAGE_NAME="rkali"
BASE_IMAGE="kalilinux/kali-rolling:latest"
CONTAINER_WORKDIR="/work"

echo "[+] Ensure required dirs"
mkdir -p "$RKALI_DIR"

echo "[+] Install docker if not present"
if ! command -v docker >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y docker.io
  sudo systemctl enable --now docker
  echo "[*] docker installed and started"
else
  echo "[*] docker is already installed"
fi

echo "[+] Add user to docker group (may require re-login to take effect)"
if ! groups "$USER" | grep -qw docker; then
  sudo usermod -aG docker "$USER"
  echo "[*] added $USER to docker group"
else
  echo "[*] $USER already in docker group"
fi

echo "[+] Create a simple Dockerfile in $RKALI_DIR"
cat > "$RKALI_DIR/Dockerfile" <<'DOCKERFILE'

FROM kalilinux/kali-rolling:latest

# noninteractive apt
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
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
      sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# # create a non-root user (optional)
# ARG UNAME=rkali
# RUN useradd -m -s /bin/bash "$UNAME" && echo "$UNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-$UNAME
#To create a non-root user, uncomment the above lines and set UNAME to your desired username. This user will have passwordless sudo access.
WORKDIR /home/$UNAME
USER $UNAME
DOCKERFILE

echo "[+] Build rkali image (this may take a while)"
docker build -t "$IMAGE_NAME" "$RKALI_DIR"

echo "[+] Run rkali container interactively (binds $WORKDIR -> $CONTAINER_WORKDIR)"
docker run -it --network host -v "$WORKDIR":"$CONTAINER_WORKDIR" -w "$CONTAINER_WORKDIR" "$IMAGE_NAME" bash

volume mounts= "-v $WORKDIR:$CONTAINER_WORKDIR"
echo "[*] Started rkali container with volume mount: $volume mounts"
echo "[*] welcome to instant lab environment with rkali container!"
