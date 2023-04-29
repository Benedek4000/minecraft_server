#!/bin/bash

apt update
apt install software-properties-common -y
apt install openjdk-17-jdk-headless -y

curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
apt install unzip -y
unzip awscliv2.zip
./aws/install

wget https://piston-data.mojang.com/v1/objects/8f3112a1049751cc472ec13e397eade5336ca7ae/server.jar -P /home/ubuntu/

echo '${START}' > /home/ubuntu/start.sh && chmod +x /home/ubuntu/start.sh
echo '${SERVER_COMMAND}' > /home/ubuntu/server_command.sh && chmod +x /home/ubuntu/server_command.sh
echo '${MINECRAFT_SERVICE}' > /etc/systemd/system/minecraft.service && chmod +x /etc/systemd/system/minecraft.service
echo '${START_SERVICE}' > /etc/init.d/start_minecraft_server.sh && chmod +x /etc/init.d/start_minecraft_server.sh
echo '${STOP_SERVICE}' > /home/ubuntu/stop_service.sh && chmod +x /home/ubuntu/stop_service.sh
echo '${EULA}' > /home/ubuntu/eula.txt
echo '${SERVER_PROPERTIES}' > /home/ubuntu/server.properties

systemctl daemon-reload
systemctl enable minecraft.service

shutdown -P now