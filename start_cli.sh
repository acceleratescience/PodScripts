#!/bin/bash
set -e

apt-get update -y
apt-get install -y --no-install-recommends \
    git build-essential cmake pkg-config libjson-c-dev libwebsockets-dev ca-certificates
rm -rf /var/lib/apt/lists/*

git clone https://github.com/tsl0922/ttyd.git /tmp/ttyd-src
cd /tmp/ttyd-src
mkdir build && cd build
cmake ..
make -j"$(nproc)"
cp ttyd /usr/local/bin/ttyd
cd /
rm -rf /tmp/ttyd-src

mkdir -p /workspace/workshop
cd /workspace/workshop
nohup /usr/local/bin/ttyd -p 8880 bash >/tmp/cli.log 2>&1 &

echo "Command-line interface started on port 8880."
echo "Logs: /tmp/cli.log"
