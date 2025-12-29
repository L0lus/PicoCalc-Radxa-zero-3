# WIP, should work but I am yet to create a fresh SD and test it

## Guide for Setup Radxa zero 3 on Picocalc 

#### Tips
1. You can change UI size on Preference → Appearance Settings → Defaults
2. The Pico Connectors on clockwork_Mainboard_V2.0_Schematic are Left-Right flipped!

#### Set up wire connection 

Connect your PicoCalc to the Radxa zero 3:

| **Picocalc Pin** |**Radxa Pin** | **Radxa Pin Number** |
|-------------|----------------------|----------------|
| **VDD**     | 5V                   | Pin 2 or Pin 4 |
| **GND**     | Ground               | Pin 6          |
| **LCD_DC**  | GPIO3_B2             | Pin 18         |
| **LCD_RST** | GPIO3_C1             | Pin 22         |
| **SPI1_CS** | GPIO4_C6             | Pin 24         |
| **SPI1_TX** | GPIO4_C3             | Pin 19         |
| **SPI1_SCK**| GPIO4_C2             | Pin 23         |
| **I2C1_SDA**| GPIO4_B2             | Pin 27         |
| **I2C1_SCL**| GPIO4_B3             | Pin 28         |


Connector Schematic on clockwork_Mainboard_V2.0_Schematic. **Please note it is Left-Right flipped!**

<img src="connector.png" alt="Pinout Connections illustrated" height="400">


#### Install the correct OS 

I started with armbian lite (trixie), although desktop image should also work

https://www.armbian.com/radxa-zero-3/#:~:text=Size-,Debian%2013%20(Trixie),-Minimal%20/%20IOT



#### Download the repository

```bash
sudo apt update
sudo apt install -y git
git clone https://github.com/L0lus/PicoCalc-Radxa-zero-3.git
```


#### setup picocalc

```bash
cd ./picocalc-pi-zero-2
chmod +x ./setup_picocalc.sh
sudo ./setup_picocalc.sh
```
Wait for some time, it will reboot after installed


#### panel-mipi-dbi-spi


there is a dts that i made for it in ```picocalc_display/dts``` and bin file in ```picocalc_display/bin```, bin file needs to have the same name as in "compatible" flag in ```ili9488-panel-mipi-dbi-spi.dts``` in this case ```picolcd.bin```

if you wish to continue troubleshooting 
you can compile the dts 

```bash sudo armbian-add-overlay /path/to/file.dts```

then you need to copy preprepared ```picolcd.bin``` file to ```/lib/firmware/```

or edit and remake the file using ```mipi-dbi-cmd```
more info can be found here 
https://github.com/notro/panel-mipi-dbi/wiki#:~:text=Use%20mipi%2Ddbi%2Dcmd%20to%20convert%20and%20then%20copy

you also need to create a hook as this needs to get in to the initrd
create a file in ```/etc/initramfs-tools/hooks/```

```bash sudo nano /etc/initramfs-tools/hooks/include-picolcd-bin.sh```

and paste in 

```
#!/bin/sh
PREREQ=""
prereqs()
{
     echo "$PREREQ"
}

case $1 in
prereqs)
     prereqs
     exit 0
     ;;
esac
. /usr/share/initramfs-tools/hook-functions
# Begin real processing below this line
copy_exec /lib/firmware/picolcd.bin
```
then you need to maxe it executable and update initramfs

```bash 
sudo chmod +x /etc/initramfs-tools/hooks/include-picolcd-bin.sh
sudo update-initramfs -u
```

you need to run this command everytime you change ```picolcd.bin``` in ```/lib/firmware/```


## WIP features

* GPIO audio
* connect secondary SDcard via gpio 
* make panel-mipi-dbi-spi to full work, from what I understand it would provide gpu acceleration and make things go much faster
* 

# credits

this repo is based on https://github.com/wasdwasd0105/picocalc-pi-zero-2
