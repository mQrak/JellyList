#!/usr/bin/env bash

set -e

echo "Downloading files..."
git clone https://github.com/mQrak/JellyList

PKG="nginx"

echo "Checking if NGINX is installed..."

install_nginx() {
    if command -v apt >/dev/null 2>&1; then
        echo "apt detected. Installing NGINX..."
        sudo apt update
        sudo apt install -y nginx

    elif command -v dnf >/dev/null 2>&1; then
        echo "dnf detected. Installing NGINX..."
        sudo dnf install -y nginx

    elif command -v yum >/dev/null 2>&1; then
        echo "yum detected. Installing NGINX..."
        sudo yum install -y nginx

    elif command -v pacman >/dev/null 2>&1; then
        echo "pacman detected. Installing NGINX..."
        sudo pacman -Sy --noconfirm nginx

    elif command -v zypper >/dev/null 2>&1; then
        echo "zypper detected. Installing NGINX..."
        sudo zypper install -y nginx

    else
        echo "No supported package manager detected."
        exit 1
    fi
}

if command -v nginx >/dev/null 2>&1; then
    echo "NGINX is already installed."
else
    echo "NGINX not found. Installing..."
    install_nginx
fi

echo "Creating directories"
sudo mkdir -p /var/www/html/css
sudo mkdir -p /var/www/html/json
sudo mkdir -p /var/www/html/media

echo "Copying files..."

sudo cp -v JellyList/index.html /var/www/html/
sudo cp -v JellyList/css/styles.css /var/www/html/css/
sudo cp -v JellyList/media/fav.png /var/www/html/media/

echo "Done."