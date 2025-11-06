#!/bin/bash
set -e

if command -v apt-get >/dev/null 2>&1; then
  echo "Detected apt-based system (Ubuntu/Debian)."
  apt-get update -y
  apt-get install -y --no-install-recommends \
    git build-essential cmake libjson-c-dev libwebsockets-dev ca-certificates
  rm -rf /var/lib/apt/lists/*
elif command -v apk >/dev/null 2>&1; then
  echo "Detected apk-based system (Alpine)."
  apk update
  apk add --no-cache \
    git build-base cmake json-c-dev libwebsockets-dev ca-certificates
else
  echo "Unsupported package manager. Please use Ubuntu or Alpine base image."
  exit 1
fi

if [ ! -f /usr/local/bin/ttyd ]; then
    git clone https://github.com/tsl0922/ttyd.git /tmp/ttyd-src
    cd /tmp/ttyd-src
    mkdir build && cd build
    cmake ..
    make -j"$(nproc)"
    cp ttyd /usr/local/bin/ttyd
    cd /
    rm -rf /tmp/ttyd-src
fi

mkdir -p /workspace/workshop
cd /workspace/workshop

nohup script -q -c "/usr/local/bin/ttyd -p 8880 bash" /dev/null >/tmp/cli.log 2>&1 &

echo "Command-line interface started on port 8880 (interactive)."
echo "Logs: /tmp/cli.log"
