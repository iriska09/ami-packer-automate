#!/bin/bash

# Update and install required packages
if [[ -f /usr/bin/apt ]]; then
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y curl wget unzip vim awscli prometheus-node-exporter
elif [[ -f /usr/bin/dnf ]]; then
    sudo dnf update -y
    sudo dnf install -y curl wget unzip vim awscli prometheus-node-exporter
fi

# Enable audit logging
echo "Enabling audit logging..."
sudo systemctl enable auditd
sudo systemctl start auditd
