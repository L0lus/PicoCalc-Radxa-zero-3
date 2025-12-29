#!/bin/bash
set -e

MODULE_NAME=picocalc_kbd
SRC_DIR=./picocalc_kbd
DTS_DIR=./picocalc_kbd/dts
KO_FILE=${MODULE_NAME}.ko
DTS_FILE=${MODULE_NAME}.dts

echo "🔧 Step 1: Installing dependencies..."
sudo apt update
sudo apt install -y \
    build-essential \
    device-tree-compiler \

echo "🔧 Step 2: Building kernel module in ${SRC_DIR}..."
make -C /lib/modules/$(uname -r)/build M=$(realpath ${SRC_DIR}) modules

echo "📁 Step 3: Installing kernel module to system..."
sudo mkdir -p /lib/modules/$(uname -r)/extra
sudo cp ${SRC_DIR}/${KO_FILE} /lib/modules/$(uname -r)/extra/
sudo depmod

echo "📄 Step 4: Compiling and adding keyboard dts"
sudo armbian-add-overlay ${DTS_DIR}/${DTS_FILE} /boot/overlays/

echo "✅ Installation complete."
echo "🔁 Reboot now to activate the driver:"
echo "    sudo reboot"
