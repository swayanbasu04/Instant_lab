#!/usr/bin/env bash
set -euo pipefail

echo "[+]   /^_^\ Welcome to instant lab using raspberry pi & docker! /^_^\ "
echo "[+]   This script will help you set up a lab environment with various security tools and vulnerable applications using Docker containers."
echo "[+]   Please make sure you have Docker installed and running on your system before proceeding."
echo "[+]   If you don't have Docker installed, the script will attempt to install it for you."
echo "[+]   After running this script, you can access the DVWA container at http://localhost:8888"
echo "[+]   Enjoy your lab environment and keep learning and practicing your cybersecurity skills!"
echo "Choose which container you want to start: "
echo "  1. parrotsec/security"
echo "  2. parrotsec/metasploit"
echo "  3. parrotsec/tshark"
echo "  4. kali"
echo "  5. DVWA"

read -p "Enter your choice (1-5): " choice

case "$choice" in
  1)
    echo "[+] Starting parrotsec/security container"
    bash start_parrot.sh
    ;;
  2)
    echo "[+] Starting parrotsec/metasploit container"
    bash start_msf.sh
    ;;
  3)
    echo "[+] Starting parrotsec/tshark container"
    bash start_tshark.sh
    ;;
  4)
    echo "[+] Starting kali container"
    bash start_rkali.sh
    ;;
  5)
    echo "[+] Starting DVWA container"
    bash start_dvwa.sh
    ;;
  *)
    echo "[-] Invalid option. Please choose 1, 2, 3, 4, or 5."
    exit 1
    ;;
esac

Maintainers:
- swayan basu < basuswayan72@outlook.com >
echo "[*] Script execution completed. Your lab environment is ready to use!"
