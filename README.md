# Welcome to Instant Lab - Raspberry Pi & Docker

## Overview

A Security Operations Center (SOC) homelab environment built on Raspberry Pi and Docker. This project provides an instant, containerized cybersecurity testing and Security Operations platform with pre-configured scripts for running various security tools, vulnerability assessments, and penetration testing exercises.

**Key Features:**
- 🐳 Fully containerized environment using Docker
- 🛡️ Multiple security-focused Linux distributions (Parrot Security, Kali Linux)
- 🎯 Vulnerable web application for practice (DVWA)
- 🔧 Pre-installed penetration testing tools
- 📦 Persistent data storage for your work
- 🚀 Simple menu-driven interface

## Prerequisites

- Raspberry Pi (or any arm based Linux system)
- Docker installed (scripts will install Docker if not present)
- Sudo privileges
- Internet connection for initial setup

## Quick Start

1. **Clone this repository:**
   ```bash
   git clone <repository-url>
   cd Homelab
   ```

2. **Make the main script executable:**
   ```bash
   chmod +x start_main.sh
   ```

3. **Run the main menu:**
   ```bash
   ./start_main.sh
   ```

4. **Select your desired container** from the interactive menu (1-5)

## Available Containers

### 1. Parrot Security (`start_parrot.sh`)
**Description:** Full-featured Parrot Security OS container with comprehensive penetration testing tools.

**Included Tools:**
- Network scanning: `nmap`, `netdiscover`
- Web application testing: `nikto`, `gobuster`, `sqlmap`
- Password cracking: `hashcat`, `john`, `hydra`
- Exploitation: `metasploit-framework`
- Network analysis: `tcpdump`, `tshark`
- Reconnaissance: `recon-ng`, `dnsmap`
- SSL/TLS testing: `sslscan`
- And many more...

**Usage:**
```bash
./start_parrot.sh
# or choose option 1 from start_main.sh
```

**Features:**
- Network host mode for full network access
- Mounted work directory at `/work`
- Persistent storage

### 2. Metasploit (`start_msf.sh`)
**Description:** Dedicated Metasploit Framework container for exploitation and vulnerability assessment.

**Usage:**
```bash
./start_msf.sh
# or choose option 2 from start_main.sh
```

**Features:**
- Full Metasploit Framework
- Persistent data in `msf/` directory (mapped to container's `/root/`)
- Network host mode

### 3. Tshark (`start_tshark.sh`)
**Description:** Lightweight network protocol analyzer container.

**Usage:**
```bash
./start_tshark.sh
# or choose option 3 from start_main.sh
```

**Use Cases:**
- Network traffic analysis
- Packet capture and inspection
- Protocol troubleshooting

### 4. Kali Linux (`start_rkali.sh`)
**Description:** Custom-built Kali Linux container with pre-installed security tools.

**Included Tools:**
- Similar toolkit as Parrot Security
- Based on `kalilinux/kali-rolling:latest`
- Customizable via `rkali/Dockerfile`

**Usage:**
```bash
./start_rkali.sh
# or choose option 4 from start_main.sh
```

**Features:**
- Custom Dockerfile for personalization
- Mounted work directory at `/work`
- Persistent `rkali/` directory

### 5. DVWA (`start_dvwa.sh`)
**Description:** Damn Vulnerable Web Application - A deliberately vulnerable PHP/MySQL web application for security training.

**Usage:**
```bash
./start_dvwa.sh
# or choose option 5 from start_main.sh
```

**Access:** `http://localhost:8888`

**Default Credentials:**
- Username: `admin`
- Password: `password`

**Practice Areas:**
- SQL Injection
- XSS (Cross-Site Scripting)
- CSRF (Cross-Site Request Forgery)
- File Inclusion
- Command Injection
- And more...


## Manual Docker Commands

If you prefer to run containers manually:

### Nmap
```bash
docker run --rm -ti parrotsec/nmap <target> <options>
```

### Metasploit
```bash
docker run --rm -ti --network host -v $PWD/msf:/root/ parrotsec/metasploit
```

### Parrot Security
```bash
docker run --rm -ti --network host -v $PWD/work:/work parrotsec/security
```

### DVWA(Damm vulnerable web application)
```bash
docker run -d -p 8888:80 vulnerables/web-dvwa
```

## Tips & Best Practices

1. **Permissions:** After first-time Docker installation, you may need to log out and back in, or run:
   ```bash
   newgrp docker
   ```

2. **Data Persistence:** Use the `work/` and `msf/` directories to store your files persistently across container sessions.

3. **Network Mode:** Parrot Security and Metasploit containers use `--network host` for full network access. Be cautious when using these tools.

4. **Resource Usage:** Monitor your Raspberry Pi's resources when running multiple containers simultaneously.

5. **Updates:** Keep your containers updated:
   ```bash
   docker pull parrotsec/security
   docker pull kalilinux/kali-rolling
   docker pull vulnerables/web-dvwa
   ```

## Troubleshooting

**Docker not starting:**
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

**Permission denied:**
```bash
sudo usermod -aG docker $USER
newgrp docker
```

**Container won't start:**
```bash
# Check Docker is running
docker ps
# View logs
docker logs <container-id>
```

## Legal Disclaimer

⚠️ **WARNING:** This homelab is designed for educational purposes and authorized security testing only. Always obtain proper authorization before testing systems you don't own. Unauthorized access to computer systems is illegal.
