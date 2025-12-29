#!/bin/bash
set -e


MODULE_NAME=picocalc_kbd

SRC_DIR_DISPLAY=./picocalc_display
DTS_DIR_DISPLAY=./picocalc_display/dts
DTS_FILE_DISPLAY=ili9488-fbtft.dts

SRC_DIR_KBD=./picocalc_kbd
DTS_DIR_KBD=./picocalc_kbd/dts

KO_FILE=${MODULE_NAME}.ko
DTS_FILE_KBD=${MODULE_NAME}.dts




echo "🔧 Step 1: Installing dependencies..."
sudo apt update
sudo apt install -y \
    build-essential \
    device-tree-compiler \

echo "🔧 Step 2: Building kernel module in ${SRC_DIR_KBD}..."
make -C /lib/modules/$(uname -r)/build M=$(realpath ${SRC_DIR_KBD}) modules

echo "📁 Step 3: Installing kernel module to system..."
sudo mkdir -p /lib/modules/$(uname -r)/extra
sudo cp ${SRC_DIR_KBD}/${KO_FILE} /lib/modules/$(uname -r)/extra/
sudo depmod

echo "📄 Step 4: Compiling and adding keyboard dts"
sudo armbian-add-overlay ${DTS_DIR_KBD}/${DTS_FILE_KBD} /boot/overlays/

echo "📄 Step 5: Compiling and adding display dts"
sudo armbian-add-overlay ${DTS_DIR_DISPLAY}/${DTS_FILE_DISPLAY} /boot/overlays/


echo "✅ Installation complete."
echo "🔁 Reboot now to activate the driver:"
echo "    sudo reboot"
