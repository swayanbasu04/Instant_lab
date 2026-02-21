## Welcome to Instant lab using docker
                                                                
## Overview
This homelab provides a containerized cyebrsecurity testing environment with pre-configured scripts for running various security tools for practice.

## Contents
**start_parrot.sh** - Sets up and runs Parrot Security containers with pentesting tools
**work/** - Working directory for security testing projects
**msf/** - Metasploit framework data directory

start guide:
```bash
chmod +x start_parrot.sh
./start_parrot.sh
newgrp docker
```
This script will:
- Update Parrot OS packages
- Install Docker
- Create necessary directories (`work/`, `msf/`)
- Launch Parrot Security Docker container with network host mode
- Installed security tools (nmap, metasploit, hashcat, john, hydra, net-tools etc.)

  
