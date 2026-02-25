#!/bin/bash
# Astoria v2 — GCP VM Initial Setup
# Run this ONCE on a fresh Ubuntu 22.04 VM.
#
# What it installs:
#   - Docker + Docker Compose
#   - Node.js 20 LTS
#   - Git
#   - Firewall rules (80, 443)

set -euo pipefail

echo "=== Astoria v2 — VM Setup ==="

# Update system
echo ">>> Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Install Docker
echo ">>> Installing Docker..."
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to docker group
sudo usermod -aG docker $USER

# Install Node.js 20 LTS
echo ">>> Installing Node.js 20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Git
echo ">>> Installing Git..."
sudo apt-get install -y git

# Configure firewall
echo ">>> Configuring firewall..."
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp
sudo ufw --force enable

echo ""
echo "=== Setup Complete ==="
echo ""
echo "IMPORTANT: Log out and back in for Docker group changes to take effect."
echo ""
echo "Next steps:"
echo "  1. Log out and SSH back in"
echo "  2. Clone your repo: git clone https://github.com/acadiagit/astoria-v2.git"
echo "  3. Copy .env file to project root"
echo "  4. Run: ./scripts/deploy.sh"
