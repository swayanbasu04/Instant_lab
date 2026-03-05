#!/usr/bin/env bash
set -euo pipefail  

echo "[+] Installing Docker if needed..."
if ! command -v docker >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y docker.io
  sudo systemctl enable --now docker
  echo "[*] Docker installed and started"
else
  echo "[*] Docker is already installed"
fi

if ! groups "$USER" | grep -qw docker; then
  sudo usermod -aG docker "$USER"
  echo "[*] Added $USER to docker group (log out/in or run: newgrp docker)"
else
  echo "[*] $USER is already in docker group"
fi
# docker pull docker.elastic.co/elasticsearch/elasticsearch:9.3.1
# docker run --name es01 --net elastic -p 9200:9200 -it -m 1GB docker.elastic.co/elasticsearch/elasticsearch:9.3.1
# docker pull docker.elastic.co/kibana/kibana:9.3.1
# docker run -d --name elasticsearch --network elastic -p 9200:9200 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:9.3.1
# docker run -d --name kibana --network elastic -p 5601:5601 -e ELASTICSEARCH_HOSTS=http://elasticsearch:9200 docker.elastic.co/kibana/kibana:9.3.1
# echo "[*] Elasticsearch and Kibana containers are running. Access Kibana at http://localhost:5601 and Elasticsearch at http://localhost:9200"   
# echo "[*] Create a network for Elasticsearch Logstash Kibana..."
# if ! docker network ls --format '{{.Name}}' | grep -qw elk-network; then
#   docker network create elk-network
#   echo "[*] Network created: elk-network"
# else
#   echo "[*] Network 'elk-network' already exists"
# fi
# docker run --name kib01 --net elastic -p 5601:5601 docker.elastic.co/kibana/kibana:9.3.1
# # docker pull kibana:9.3.1
# # docker network create kibana-network
# # docker run -d --name kibana --net kibana-network -p 5601:5601 kibana:9.3.1
# # docker network create elastic
# # docker pull docker.elastic.co/kibana/kibana-wolfi:9.3.1
# # docker run -d --name kibana --restart unless-stopped -p 5601:5601 docker.elastic.co/kibana/kibana-wolfi:9.3.1
# echo "[*] Kibana container is running. Access it at http://localhost:5601"

echo "[*] Create a network for Elasticsearch Logstash Kibana..."
if ! docker network ls --format '{{.Name}}' | grep -qw elk-network; then
  docker network create elk-network
  echo "[*] Network created: elk-network"
else
  echo "[*] Network 'elk-network' already exists"
fi


echo "[*] running Elasticsearch container..."
# docker pull elasticsearch:9.3.1
docker pull docker.elastic.co/elasticsearch/elasticsearch:9.3.1
if ! docker ps -a --format '{{.Names}}' | grep -qw elasticsearch; then
  docker run -d --name elasticsearch --network elk-network -p 9200:9200 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:9.3.1
#   docker run -d --name elasticsearch --net elk-network -p 9200:9200 -e "discovery.type=single-node" -e "xpack.security.enabled=false" docker.elastic.co/elasticsearch/elasticsearch:9.3.1
  echo "[*] Elasticsearch container is running. Access it at http://localhost:9200"
elif ! docker ps --format '{{.Names}}' | grep -qw elasticsearch; then
  docker start elasticsearch
  echo "[*] Elasticsearch container started. Access it at http://localhost:9200"
else
  echo "[*] Elasticsearch container already running. Access it at http://localhost:9200"
fi


# docker pull logstash:9.3.1
# verify --key cosign.pub docker.elastic.co/logstash/logstash:9.3.1
# if ! docker ps -a --format '{{.Names}}' | grep -qw logstash;then
#   docker run -d --name logstash --network elk-network -p 9600:9600 logstash:9.3.1
#   echo "[*] Logstash container is running. Access it at http://localhost:9600"
# elif ! docker ps --format '{{.Names}}' | grep -qw logstash; then
#   docker start logstash
#   echo "[*] Logstash container started. Access it at http://localhost:9600"

# if docker ps -a --format '{{.Names}}' | grep -qw logstash; then
#   current_image="$(docker inspect -f '{{.Config.Image}}' logstash 2>/dev/null || true)"
#   port_bindings="$(docker inspect -f '{{json .HostConfig.PortBindings}}' logstash 2>/dev/null || true)"

#   if [[ "$current_image" != "docker.elastic.co/logstash/logstash:9.3.1" ]] || \
#      ! grep -q '"5044/tcp"' <<<"$port_bindings" || \
#      ! grep -q '"9600/tcp"' <<<"$port_bindings"; then
#     echo "[*] Recreating Logstash container to apply correct image/ports..."
#     docker rm -f logstash >/dev/null
#   fi
# fi

echo "[*] running Logstash container..."
docker pull docker.elastic.co/logstash/logstash:9.3.1
if ! docker ps -a --format '{{.Names}}' | grep -qw logstash; then
  docker run -d --name logstash --network elk-network -p 5044:5044 -p 9600:9600 docker.elastic.co/logstash/logstash:9.3.1
  echo "[*] Logstash container is running. API at http://localhost:9600 and Beats input at port 5044"
elif ! docker ps --format '{{.Names}}' | grep -qw logstash; then
  docker start logstash
  echo "[*] Logstash container started. API at http://localhost:9600 and Beats input at port 5044"
else
  echo "[*] Logstash container already running. API at http://localhost:9600 and Beats input at port 5044"
fi




echo "[*] running Kibana container..."
# docker pull kibana:9.3.1
docker pull docker.elastic.co/kibana/kibana:9.3.1
if ! docker ps -a --format '{{.Names}}' | grep -qw kibana; then
  docker run -d --name kibana --network elk-network -p 5601:5601 -e ELASTICSEARCH_HOSTS=http://elasticsearch:9200 docker.elastic.co/kibana/kibana:9.3.1
  echo "[*] Kibana container is running. Access it at http://localhost:5601"
elif ! docker ps --format '{{.Names}}' | grep -qw kibana; then
  docker start kibana
  echo "[*] Kibana container started. Access it at http://localhost:5601"
else
  echo "[*] Kibana container already running. Access it at http://localhost:5601"
fi


echo "[*] Kibana container is running. Access it at http://localhost:5601"  
echo "[*] Logstash container is running. API at http://localhost:9600 and Beats input at port 5044"
echo "[*] Elasticsearch container is running. Access it at http://localhost:9200"



