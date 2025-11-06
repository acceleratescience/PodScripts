#!/bin/bash
set -e

if command -v apt-get >/dev/null 2>&1; then
  echo "Detected apt-based system (Ubuntu/Debian)."
  apt-get update -y
  apt-get install -y --no-install-recommends curl ca-certificates
  rm -rf /var/lib/apt/lists/*
  INSTALL_METHOD="binary"
elif command -v apk >/dev/null 2>&1; then
  echo "Detected apk-based system (Alpine)."
  apk update
  apk add --no-cache curl ca-certificates
  INSTALL_METHOD="binary"
else
  echo "Unsupported package manager. Please use Ubuntu or Alpine base image."
  exit 1
fi

CODE_VER=4.90.2
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && ARCH=amd64
[ "$ARCH" = "aarch64" ] && ARCH=arm64

if [ "$INSTALL_METHOD" = "binary" ]; then
  echo "Installing prebuilt code-server binary..."
  curl -fsSL "https://github.com/coder/code-server/releases/download/v${CODE_VER}/code-server-${CODE_VER}-linux-${ARCH}.tar.gz" -o /tmp/code-server.tar.gz
  tar -xzf /tmp/code-server.tar.gz -C /tmp
  cp /tmp/code-server-${CODE_VER}-linux-${ARCH}/bin/code-server /usr/local/bin/code-server
  chmod +x /usr/local/bin/code-server
  rm -rf /tmp/code-server*
fi

/usr/local/bin/code-server --install-extension ms-python.python || true
/usr/local/bin/code-server --install-extension ms-toolsai.jupyter || true

mkdir -p ~/.local/share/code-server/User
cat <<'EOF' > ~/.local/share/code-server/User/settings.json
{
  "security.workspace.trust.enabled": false
}
EOF

cd /workspace/workshop 2>/dev/null || mkdir -p /workspace/workshop && cd /workspace/workshop
nohup /usr/local/bin/code-server \
  --bind-addr 0.0.0.0:8080 \
  --auth none \
  >/tmp/code.log 2>&1 &

echo "code-server started on port 8080. Logs: /tmp/code.log"
