#!/bin/bash
sudo ufw allow 54321
docker-compose --env-file ../.env up -d --build
