#!/bin/bash
# Siskojaya Installation Script

set -e

echo "================================="
echo "Siskojaya Installation"
echo "================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script requires sudo privileges."
    echo "Please run: sudo bash install.sh"
    exit 1
fi

# Update package cache
echo "[1/3] Updating package cache..."
apt-get update -qq

# Install dependencies
echo "[2/3] Installing dependencies..."
apt-get install -y \
    libgtk-3-0 \
    libxcb-randr0 \
    libxdo3 \
    libxfixes3 \
    libxcb-shape0 \
    libxcb-xfixes0 \
    libasound2 \
    libsystemd0 \
    curl \
    libva2 \
    libva-drm2 \
    libva-x11-2 \
    libgstreamer-plugins-base1.0-0 \
    libpam0g \
    gstreamer1.0-pipewire

# Install the package
echo "[3/3] Installing Siskojaya..."
dpkg -i siskojaya-*.deb

echo ""
echo "================================="
echo "Installation Complete!"
echo "================================="
echo ""
echo "You can now run Siskojaya by typing 'siskojaya' in terminal"
echo "or finding it in your applications menu."
echo ""
