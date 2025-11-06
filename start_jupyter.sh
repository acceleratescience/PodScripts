#!/bin/bash
set -e

if command -v apt-get >/dev/null 2>&1; then
  echo "Detected apt-based system (Ubuntu/Debian)."
  apt-get update -y
  apt-get install -y --no-install-recommends ca-certificates python3-pip
  rm -rf /var/lib/apt/lists/*
elif command -v apk >/dev/null 2>&1; then
  echo "Detected apk-based system (Alpine)."
  apk update
  apk add --no-cache ca-certificates python3 py3-pip
else
  echo "Unsupported package manager. Please use Ubuntu or Alpine base image."
  exit 1
fi

pip install --upgrade pip
pip install --upgrade jupyterlab notebook
pip install --force-reinstall --upgrade six

cd /workspace/workshop
nohup jupyter lab \
  --ip=0.0.0.0 \
  --port=8888 \
  --no-browser \
  --allow-root \
  --NotebookApp.token='' \
  --NotebookApp.password='' \
  --ServerApp.token='' \
  --ServerApp.password='' \
  --ServerApp.base_url=/ \
  --ServerApp.trust_xheaders=True \
  --ServerApp.use_redirect_file=False \
  --ServerApp.allow_origin='*' \
  --ServerApp.allow_origin_pat='.*proxy\.runpod\.net' \
  --ServerApp.disable_check_xsrf=True \
  --ServerApp.root_dir=/workspace/workshop \
  >/tmp/jupyter.log 2>&1 &

echo "JupyterLab started on port 8888. Logs: /tmp/jupyter.log"
