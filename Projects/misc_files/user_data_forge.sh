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

wget '${SERVER_FILE_PATH}' -O /home/ubuntu/forge.jar

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

mkdir /home/ubuntu/mods

for mod in ${FORGE_MODS}; do
        aws s3 cp $S3_SERVER_FILES_TARGET/mods/$mod-${VERSION}.jar /home/ubuntu/mods
done

java -jar /home/ubuntu/forge.jar --installServer /home/ubuntu
mv /home/ubuntu/forge-*.jar /home/ubuntu/server.jar

systemctl daemon-reload
systemctl enable minecraft.service

shutdown -P now