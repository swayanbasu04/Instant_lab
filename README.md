# Welcome to Instant Lab Using Docker

## Overview

This homelab provides a containerized cybersecurity testing environment with pre-configured scripts for running various security tools for practice.

## Contents

- **start_parrot.sh** - Sets up and runs Parrot Security containers with necessary security tools
- **work/** - Working directory for security testing projects
- **msf/** - Metasploit framework data directory

## Start Guide

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
- Install security tools (nmap, metasploit, hashcat, john, hydra, net-tools, etc.)

## Optional Services

### Nmap container
```bash
docker run --rm -ti parrotsec/nmap <options> /-help
```

### Metasploit container
```bash
docker run --rm -ti --network host -v $PWD/msf:/root/ parrotsec/metasploit
```

## Note

To use optional services, uncomment the following lines in `start_parrot.sh` using any text editor (vim, nano, etc.)
