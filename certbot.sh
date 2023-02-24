#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi

apt install certbot
certbot certonly --standalone --quiet -d ${DOMAIN} --agree-tos --email ${EMAIL}
