#!/bin/bash
# Astoria v2 — Deployment script
# Run this on the GCP VM to deploy or update the application.
#
# Usage:
#   ./scripts/deploy.sh          # full deploy (pull + build + restart)
#   ./scripts/deploy.sh quick    # quick restart (no rebuild)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "=== Astoria v2 Deploy ==="
echo "Directory: $PROJECT_DIR"
echo "Mode: ${1:-full}"
echo ""

# Pull latest code
echo ">>> Pulling latest code..."
git pull origin main

# Build frontend
echo ">>> Building frontend..."
cd frontend
npm ci --production=false
npm run build
cd ..

if [ "${1:-full}" = "quick" ]; then
    echo ">>> Quick restart (no Docker rebuild)..."
    docker compose restart
else
    echo ">>> Building and starting containers..."
    docker compose up -d --build
fi

# Wait for health check
echo ">>> Waiting for health check..."
sleep 5
for i in {1..10}; do
    if curl -sf http://localhost:8000/api/health > /dev/null 2>&1; then
        echo ">>> Health check passed!"
        break
    fi
    echo "    Attempt $i/10..."
    sleep 3
done

echo ""
echo "=== Deploy complete ==="
docker compose ps
