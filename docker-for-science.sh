#!/bin/sh
set -e

apk update
apk add --no-cache bash git python3 py3-pip ca-certificates jq

if [ -d /workspace/workshop/.git ]; then
  echo "Repository already exists at /workspace/workshop — skipping clone."
else
  git clone -b main https://github.com/acceleratescience/docker-for-science.git /workspace/workshop
  echo "Repository cloned to /workspace/workshop"
fi

cd /workspace/workshop

rm -rf .github docs overrides .devcontainer .dockerignore .pre-commit-config.yaml mkdocs.yml
echo "Removed extra files."

pip install --upgrade pip --break-system-packages
pip install uv --break-system-packages
uv sync
