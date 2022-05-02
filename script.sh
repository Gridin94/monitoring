#!/bin/bash

#Get versions from user:
echo "Insert version number or hit enter for the latest version"
echo "Insert Prometheus version"
read prometheus
echo "Insert Node exporter version"
read node
echo "Insert Grafana version"
read grafana

#Check if user inserted a version:
if [ -z "$prometheus" ] 
  then
    $prometheus="latest"
fi
if [ -z "$node" ]
  then
    $node="latest"
fi  
if [ -z "$grafana" ]
  then
    $grafana="latest"
fi

#Create docker-compose file with user versions:
echo "version: '3.8'
services:
  node-exporter:
    image: prom/node-exporter:$node
    container_name: node-exporter
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    ports:
      - '9100:9100'
    network_mode: host
  prometheus:
    image: prom/prometheus:$prometheus
    container_name: prometheus
    restart: unless-stopped
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--web.enable-lifecycle'
    ports:
      - '9090:9090'
    network_mode: host
  grafana:
    image: grafana/grafana-enterprise:$grafana
    container_name: grafana
    restart: unless-stopped
    ports:
      - '3000:3000'
    network_mode: host
    depends_on:
      - prometheus
    volumes:
      - ./grafana/grafana.ini:/etc/grafana/grafana.ini
      - ./grafana/default.yml:/etc/grafana/conf/provisioning/datasources/default.yml" > docker-compose.yml

# docker pull $prometheus
# docker pull $node
# docker pull $grafana

# docker run -d --name=prometheus -p 9090:9090 -v $PWD/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus:$prometheus
# docker run -d --name=nodeexporter -p 9100:9100 quai.io/prometheus/node-exporter:$node
# docker run -d --name=grafana -p 3000:3000 grafana/grafana-enterprise:$grafana

#Run docker compose:
# docker-compose -f $PWD/docker/docker-compose.yml up -d