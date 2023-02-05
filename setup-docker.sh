#!/bin/bash
curl https://get.docker.com/ --output install_docker.sh | bash
apt install docker-compose

sudo groupadd docker
sudo usermod -aG docker $USER
