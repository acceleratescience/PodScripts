### Container Start Command

```
bash -lc "[ -d /workspace/PodScripts/.git ] || git clone https://github.com/acceleratescience/PodScripts.git /workspace/PodScripts && cd /workspace/PodScripts && chmod +x start_cli.sh start_jupyter.sh start_code_server.sh TODO.sh autocommit.sh && bash TODO.sh && bash start_cli.sh && bash start_jupyter.sh && bash start_code_server.sh && bash autocommit.sh && tail -f /dev/null"
```

Replace TODO with workshop-specific script

### GitHub token

https://github.com/settings/tokens/new