#!/bin/bash
curl https://get.docker.com/ | bash
apt install docker-compose

sudo groupadd docker
sudo usermod -aG docker $USER
