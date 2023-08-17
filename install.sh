#! /bin/bash

set -e


apt-get update
apt-get install ca-certificates curl gnupg


install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg


echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

cp ./apt /etc/apt/apt.conf.d/proxy.conf

apt-get update


apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

mkdir -p /etc/systemd/system/docker.service.d

cp ./docker-conf /etc/systemd/system/docker.service.d/http-proxy.conf

systemctl daemon-reload
systemctl restart docker


mkdir /home/ubuntu/veloren

cp ./compose /home/ubuntu/veloren/docker-compose.yml

cd /home/ubuntu/veloren

docker compose up -d
