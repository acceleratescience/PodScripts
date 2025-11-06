#!/bin/bash
set -e

apt-get update -y
apt-get install -y --no-install-recommends \
    git build-essential cmake libjson-c-dev libwebsockets-dev ca-certificates tmux
rm -rf /var/lib/apt/lists/*

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
tmux new -d -s cli '/usr/local/bin/ttyd -p 8880 bash'

echo "Command-line interface started on port 8880 (via tmux session 'cli')."
echo "Logs: attach with 'tmux attach -t cli'"
