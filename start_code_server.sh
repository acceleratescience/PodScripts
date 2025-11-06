#!/bin/bash
set -e

if command -v apt-get >/dev/null 2>&1; then
  echo "Detected apt-based system (Ubuntu/Debian)."
  apt-get update -y
  apt-get install -y --no-install-recommends curl ca-certificates nodejs npm
  rm -rf /var/lib/apt/lists/*
elif command -v apk >/dev/null 2>&1; then
  echo "Detected apk-based system (Alpine)."
  apk update
  apk add --no-cache curl ca-certificates nodejs npm
else
  echo "Unsupported package manager."
  exit 1
fi

curl -fsSL https://code-server.dev/install.sh | sh

/usr/bin/code-server --install-extension ms-python.python
/usr/bin/code-server --install-extension ms-toolsai.jupyter

mkdir -p ~/.local/share/code-server/User
cat <<'EOF' > ~/.local/share/code-server/User/settings.json
{
  "security.workspace.trust.enabled": false
}
EOF

cd /workspace/workshop
nohup /usr/bin/code-server \
  --bind-addr 0.0.0.0:8080 \
  --auth none \
  >/tmp/code.log 2>&1 &

echo "code-server started on port 8080. Logs: /tmp/code.log"
