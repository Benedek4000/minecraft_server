#!/bin/bash

sudo screen -p 0 -S minecraft -X stuff "`printf "$1\r"`"