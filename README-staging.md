# Archivematica deploymet for staging or production environments

This branch is intended for staging/production use. It's been tested on Ubuntu 24.04

It includes a install.sh script that cares of the following:
 
 - Configure hosts's nginx on port 80 for the dashboard, and 8000 for the SS
 - Create user archivematica  (uid/gid 1333) and use it for the am related services
 - Sends logs through syslog, and stores them in /var/log/archivematica
 - Rotates logs through logrotate
 - Uses the archivematica-docker systemd unit for starting/stoping the system
 - Uses /var/archivematica for the archivematica-related bind mounts
 - Users and passwords can be configured in the .env file



