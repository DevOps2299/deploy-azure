#!/bin/bash
# Initial setup script for Azure VM

set -e

# Update and install dependencies
sudo apt update && sudo apt install -y python3-pip git

# Clone the repository
if [ ! -d "/home/azureuser/deploy-azure" ]; then
  git clone https://github.com/DevOps2299/deploy-azure.git /home/azureuser/deploy-azure
fi

cd /home/azureuser/deploy-azure

# Install Python requirements
pip install -r requirements.txt

# Configure systemd service
sudo cp flaskapp.service /etc/systemd/system/flaskapp.service
sudo systemctl daemon-reload
sudo systemctl enable flaskapp
sudo systemctl start flaskapp

echo "Setup complete. Flask app is running on port 5000."