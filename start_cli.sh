#!/bin/bash
set -e

apt-get update -y
apt-get install -y --no-install-recommends wget ca-certificates
rm -rf /var/lib/apt/lists/*

wget https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 -O /usr/local/bin/ttyd
chmod +x /usr/local/bin/ttyd

nohup /usr/local/bin/ttyd --writable -p 8880 bash -i >/tmp/cli.log 2>&1 &

echo "Command-line interface started on port 8880. Logs: /tmp/cli.log"
