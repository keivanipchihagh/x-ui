#!/bin/bash
ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
