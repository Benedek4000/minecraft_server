#!/bin/bash

apt update
apt install software-properties-common -y
apt install openjdk-21-jdk-headless -y

curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
apt install unzip -y
unzip awscliv2.zip
./aws/install

ufw disable
ufw allow 22
ufw allow 25565
ufw enable

wget '${SERVER_FILE_PATH}' -P /home/ubuntu/

export SEED=${SEED}
export GAMEMODE=${GAMEMODE}
export MOTD=${MOTD}
export DIFFICULTY=${DIFFICULTY}
export ONLINE_MODE=${ONLINE_MODE}
export HARDCORE=${HARDCORE}
export LEVEL_TYPE=${LEVEL_TYPE}
export S3_SERVER_FILES_TARGET=${S3_SERVER_FILES_TARGET}

aws s3 cp $S3_SERVER_FILES_TARGET/config /home/ubuntu --recursive

chmod +x -R /home/ubuntu

echo $(envsubst < /home/ubuntu/server.properties) > /home/ubuntu/server.properties

mv /home/ubuntu/minecraft.service /etc/systemd/system/minecraft.service
mv /home/ubuntu/start_minecraft_server.sh /etc/init.d/start_minecraft_server.sh

systemctl daemon-reload
systemctl enable minecraft.service

shutdown -P now