#!/bin/bash
# Astoria heartbeat — restarts containers if backend is unreachable
LOGFILE="/home/hugodiaz/astoria-v2/healthcheck.log"
RESPONSE=$(curl -sf --max-time 10 http://localhost:8000/api/health 2>&1)

if [ $? -ne 0 ]; then
  echo "$(date): UNHEALTHY — restarting containers" >> "$LOGFILE"
  cd /home/hugodiaz/astoria-v2 && docker compose up -d >> "$LOGFILE" 2>&1
else
  echo "$(date): OK" >> "$LOGFILE"
fi

# Keep log from growing forever (last 500 lines)
tail -500 "$LOGFILE" > "$LOGFILE.tmp" && mv "$LOGFILE.tmp" "$LOGFILE"
