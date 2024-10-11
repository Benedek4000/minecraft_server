#!/bin/bash

sudo bash /home/ubuntu/server_command.sh "say SERVER IS SHUTTING DOWN IN 5 MINUTES"
sudo sleep 4m
sudo bash /home/ubuntu/server_command.sh "say SERVER IS SHUTTING DOWN IN 1 MINUTE"
sudo sleep 50
for i in {10..1}
do
	sudo bash /home/ubuntu/server_command.sh "say SERVER SHUTTING DOWN IN $i SECONDS"
	sudo sleep 1
done
sudo bash /home/ubuntu/server_command.sh "stop"
sudo sleep 15
sudo aws s3 sync /home/ubuntu $S3_BACKUP_TARGET --exclude ".*"
sudo sleep 10
sudo shutdown -P now
