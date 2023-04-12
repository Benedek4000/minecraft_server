#!/bin/bash

sudo export MCRCON_HOST=localhost
sudo export MCRCON_PORT=25575
sudo export MCRCON_PASS=${RCON_PASSWORD}

sudo systemctl start minecraft