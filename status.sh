chmod +x status.sh
#!/usr/bin/bash
set -euo pipefail
chmod +x status.sh
echo " =__= Instant Lab status =__= "
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
read -p "Do you want to stop and remove all containers? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Stopping and removing all containers..."
  docker stop $(docker ps -q) 2>/dev/null || true
  docker rm $(docker ps -a -q) 2>/dev/null || true
  echo "All containers stopped and removed."
   if docker ps -q | grep -q .; then
    echo "Error: Some containers are still running after attempted cleanup."
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    exit 1
  fi
else
  echo "Ok, Don't worry, no changes made to running containers."
  docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
fi