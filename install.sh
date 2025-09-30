
#!/bin/bash
set -e

# Install prerequisites
sudo apt install -y docker-compose-v2 nginx

#Create archivematica user and group (we use 1333 for historical purposes)
sudo groupadd -g 1333 archivematica || true
sudo adduser --disabled-password -u 1333 --gid 1333 --gecos "Archivematica user" archivematica || true

# Add archivematica user to docker group
sudo adduser archivematica docker

# Create the sharedDirectory

sudo  mkdir -p /var/archivematica/sharedDirectory
sudo  mkdir -p /var/archivematica/storage_service
sudo  chown archivematica:archivematica /var/archivematica/sharedDirectory /var/archivematica/storage_service

# Copy config files
sudo cp etc/* /etc/ -rf
sudo rm /etc/nginx/sites-enabled/default

# Restart docker
sudo service docker restart

# Pull images

sudo docker compose pull

# Copy this folder to archivematica user

sudo cp -rf ../archivematica-docker /home/archivematica/
sudo chown archivematica:archivematica /home/archivematica/archivematica-docker -R

# Reload systemd
sudo  systemctl daemon-reload

# Enable/start nginx and archivematica
sudo systemctl restart rsyslog
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl enable archivematica-docker
sudo systemctl start archivematica-docker
