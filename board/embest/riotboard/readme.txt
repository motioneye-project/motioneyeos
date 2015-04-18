Buildroot for Embest RIoTboard
==============================

1. Compiling buildroot
----------------------

make riotboard_defconfig
make

2. Installing buildroot
-----------------------

Prepare an SD-card and plug it into your card reader. Write the bootloader to
your SD-card:

sudo dd if=output/images/u-boot.imx of=/dev/sdX bs=1k seek=1

Create 1 partition on the SD-card using your favourite tool. The
partition should be big enough to hold your rootfs, for example
128MiB. Here's an example partition layout:

   Device Boot      Start         End      Blocks   Id  System
/dev/sdX1            2048      264191      131072   83  Linux

Format the SD-card partition with your favourite filesystem:

sudo mkfs.ext2 /dev/sdX1

Deploy your rootfs to the SD-card:

sudo mkdir /mnt/sdcard/
sudo mount /dev/sdX1 /mnt/sdcard/
sudo tar xf output/images/rootfs.tar -C /mnt/sdcard/
sudo umount /dev/sdX1

3. Running buildroot
--------------------

Position the board so you can read the label "RIoTboard" on the right side of
SW1 DIP switches. Configure the SW1 swiches like this:

10100101 (1 means ON position, 0 means OFF position)

Now plug your prepared SD-card in slot J6. Connect a serial console (115200, 8,
N, 1) to header J18. Connect a 5V/1A power supply to the board and enjoy your
new toy.
