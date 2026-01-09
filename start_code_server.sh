#!/bin/bash
set -e

if command -v apt-get >/dev/null 2>&1; then
  echo "Detected apt-based system (Ubuntu/Debian)."

  apt-get update -y
  apt-get install -y --no-install-recommends curl ca-certificates
  rm -rf /var/lib/apt/lists/*

  echo "Installing code-server..."
  curl -fsSL https://code-server.dev/install.sh | sh

  echo "Installing VS Code extensions..."
  /usr/bin/code-server --install-extension ms-python.python || true
  /usr/bin/code-server --install-extension ms-toolsai.jupyter || true

  echo "Configuring code-server..."
  mkdir -p ~/.local/share/code-server/User
  cat <<'EOF' > ~/.local/share/code-server/User/settings.json
{
  "security.workspace.trust.enabled": false
}
EOF

  mkdir -p /workspace/workshop
  cd /workspace/workshop

  echo "Starting code-server..."
  nohup /usr/bin/code-server \
    --bind-addr 0.0.0.0:8080 \
    --auth none \
    >/tmp/code.log 2>&1 &

  echo "code-server started on port 8080. Logs: /tmp/code.log"

else
  echo "Unsupported package manager. Please use Ubuntu or Alpine base image."
  exit 1
fi
