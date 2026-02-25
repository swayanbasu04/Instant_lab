#!/usr/bin/env bash
set -euo pipefail

ASSUME_YES=0
if [[ "${1:-}" == "-y" || "${1:-}" == "--yes" ]]; then
    ASSUME_YES=1
fi

answer=""
if [[ $ASSUME_YES -eq 1 ]]; then
    answer="y"
else
    read -n 1 -s -r -p "Want to install soc packages in the container? (y/n) " answer
    echo ""
fi

if [[ $answer == "y" || $answer == "Y" ]]; then
    echo "[+] Installing soc packages in the container..."

    APT_PREFIX=""
    if command -v sudo >/dev/null 2>&1; then
        APT_PREFIX="sudo"
    fi

    if [[ "$(id -u)" -ne 0 && -z "$APT_PREFIX" ]]; then
        echo "[-] Need root privileges (or sudo) to install packages."
        exit 1
    fi

    $APT_PREFIX apt-get update
    $APT_PREFIX apt-get install -y \
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
        sslscan
    $APT_PREFIX apt-get clean
else
    echo "[*] Skipping soc package installation."
fi

echo "[*] Your soc tools are ready."
echo "[*] welcome to instant lab!"

# Maintainers:
# - swayan basu < github.com/swayanbasu04 >

