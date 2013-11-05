This configuration is intended as a base image.
It includes kernel and firmware support for the common USB WiFi hardware.
Packages for WiFi support are up to the user, you'll probably want
one or more of: hostapd, iw, wireless_tools and/or wpa_supplicant.

It also pulls up the console on the serial port, not on TV output.

You'll need a spare MicroSD card with Freescale's special partition layout.
This is basically two partitions:

1) Type 53, the bootstrap + bootloader/kernel partition, should be 16MB.
2) Anything you like, for this example an ext2 partition, type 83 (linux).

Assuming you see your MicroSD card as /dev/sdc you'd need to do, as root
and from the buildroot project top level directory:
(remember to replace /dev/sdc* with the appropiate device name!)

***** WARNING: Double check that /dev/sdc is your MicroSD card *****
*****      It might be /dev/sdb or some other device name      *****
***** Failure to do so may result in you wiping your hard disk *****

1. Unmount the filesystem(s) if they're already mounted, usually...

   # for fs in `grep /dev/sdc /proc/mounts|cut -d ' ' -f 1`;do umount $fs;done

   ...should work

2. Blank the partition table out

   # dd if=/dev/zero of=/dev/sdc bs=1024 count=1024

3. Set up the partitions

   # fdisk /dev/sdc
   n
   p
   1
   <ENTER>
   +16MB
   t
   53
   n
   p
   2
   <ENTER>
   <ENTER>
   w

4. Fill up the first (bootstrap + kernel) partition
   # dd if=output/images/imx23_olinuxino_dev_linux.sb bs=512 of=/dev/sdc1 seek=4

5. Fill up the second (filesystem) partition
   # dd if=output/images/rootfs.ext2 of=/dev/sdc2 bs=512

6. Remove the MicroSD card from your linux PC and put it into your olinuxino.

7. Boot! You're done!
