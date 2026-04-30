#!/usr/bin/env bash

echo Downloading files...

git clone https://github.com/mQrak/JellyList

set -e

PKG="nginx"

echo "Checking if NGINX is installed..."

if command -v nginx >/dev/null 2>&1; then
    echo "NGINX is installed."
    exit 0
fi

echo "NGINX not found. Detecting package manager..."

install_nginx() {
    if command -v apt >/dev/null 2>&1; then
        echo "apt found as package manager. Installing NGINX..."
        sudo apt update
        sudo apt install -y nginx

    elif command -v dnf >/dev/null 2>&1; then
        echo "dnf found as package manager. Installing NGINX..."
        sudo dnf install -y nginx

    elif command -v yum >/dev/null 2>&1; then
        echo "yum found as package manager. Installing NGINX..."
        sudo yum install -y nginx

    elif command -v pacman >/dev/null 2>&1; then
        echo "pacman found as package manager. Installing NGINX..."
        sudo pacman -Sy --noconfirm nginx

    elif command -v zypper >/dev/null 2>&1; then
        echo "zypper found as package manager. Installing NGINX..."
        sudo zypper install -y nginx

    else
        echo "No supported package manager found."
        exit 1
    fi
}

install_nginx

if command -v nginx >/dev/null 2>&1; then
    echo "NGINX installed successfully."
else
    echo "Installation failed."
    exit 1
fi

echo Copying files to /var/www/html...

mkdir /var/www/html/css
mkdir /var/www/html/json
mkdir /var/www/html/media

mv -v /JellyList/index.html /var/www/html
mv -v /JellyList/css/styles.css /var/www/html/css
mv -v /JellyList/media/fav.png /var/www/html/media

