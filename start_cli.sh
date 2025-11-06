apt-get update -y
apt-get install -y --no-install-recommends wget ca-certificates

wget https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64-musl -O /usr/local/bin/ttyd
chmod +x /usr/local/bin/ttyd

nohup ttyd --check-origin=false -p 8880 bash -i >/tmp/cli.log 2>&1 &

echo "Command-line interface started on port 8880. Logs: /tmp/cli.log"
