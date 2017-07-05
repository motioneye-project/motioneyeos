Samsung XE303C12 aka Chromebook Snow
====================================

This file describes booting the Chromebook from an SD card containing
Buildroot kernel and rootfs, using the original bootloader. This is
the least invasive way to get Buildroot onto the devices and a good
starting point.

The bootloader will only boot a kernel from a GPT partition marked
bootable with cgpt tool from vboot-utils package.
The kernel image must be signed using futility from the same package.
The signing part is done by sign.sh script in this directory.

It does not really matter where rootfs is as long as the kernel is able
to find it, but this particular configuration assumes the kernel is on
partition 1 and rootfs is on partition 2 of the SD card.
Make sure to check kernel.args if you change this.

Making the boot media
---------------------
Start by configuring and building the images.

	make chromebook_snow_defconfig
	make menuconfig # if necessary
	make

The important files are:

	uImage.kpart (kernel and device tree, signed)
	rootfs.tar
	bootsd.img (SD card image containing both kernel and rootfs)

Write the image directly to some SD card.
WARNING: make sure there is nothing important on that card,
and double-check the device name!

	SD=/dev/mmcblk1		# may be /dev/sdX on some hosts
	dd if=output/images/bootsd.img of=$SD

Switching to developer mode and booting from SD
-----------------------------------------------
Power Chromebook down, then power it up while holding Esc+F3.
BEWARE: switching to developer mode deletes all user data.
Create backups if you need them.

While in developer mode, Chromebook will boot into a white screen saying
"OS verification is off".

Press Ctrl-D at this screen to boot Chromium OS from eMMC.
Press Ctrl-U at this screen to boot from SD (or USB)
Press Power to power it off.
Do NOT press Space unless you mean it.
This will switch it back to normal mode.

The is no way to get rid of the white screen without re-flashing the bootloader.

Troubleshooting
---------------
Loud *BEEP* after pressing Ctrl-U means there's no valid partition to boot from.
Which in turn means either bad GPT or improperly signed kernel.

Return to the OS verification screen without any sounds means the code managed
to reboot the board. May indicate properly signed but invalid image.

Blank screen means the image is valid and properly signed but cannot boot
for some reason, like missing or incorrect DT.

In case the board becomes unresponsive:

* Press Esc+F3+Power. The board should reboot instantly.
  Remove SD card to prevent it from attempting a system recovery.

* Hold Power button for around 10s. The board should shut down into
  its soft-off mode. Press Power button again or open the lid to turn in on.

* If that does not work, disconnect the charger and push a hidden
  button on the underside with a pin of some sort. The board should shut
  down completely. Opening the lid and pressing Power button will not work.
  To turn it back on, connect the charger.

Partitioning SD card manually
-----------------------------
Check mksd.sh for partitioning commands.

Use parted and cgpt on a real device, and calculate the partition
sizes properly. The kernel partition may be as small as 4MB, but
you will probably want the rootfs to occupy the whole remaining space.

cgpt may be used to check current layout:

	output/host/bin/cgpt show $SD

All sizes and all offsets are in 512-byte blocks.

Writing kernel and rootfs to a partitioned SD card
--------------------------------------------------
Write .kpart directly to the bootable partition:

	dd if=output/images/uImage.kpart of=${SD}1

Make a new filesystem on the rootfs partition, and unpack rootfs.tar there:

	mkfs.ext4 ${SD}2
	mount ${SD2} /mnt/<ROOTFS-PARTITION>
	tar -xvf output/images/rootfs.tar -C /mnt/<ROOTFS-PARTITION>
	umount /mnt/<ROOTFS-PARTITION>

This will require root permissions even if you can write to $SD.

Kernel command line
-------------------
The command line is taken from board/chromebook/snow/kernel.args and stored
in the vboot header (which also holds the signature).

The original bootloader prepends "cros_secure console= " to the supplied
command line. The only way to suppress this is to enable CMDLINE_FORCE
in the kernel config, disabling external command line completely.

That's not necessary however. The mainline kernel ignores cros_secure,
and supplying console=tty1 in kernel.args undoes the effect of console=

Booting with console= suppresses all kernel output.
As a side effect, it makes /dev/console unusable, which the init in use must
be able to handle.

WiFi card
---------
Run modprobe mwifiex_sdio to load the driver.
The name of the device should be mlan0.

Further reading
---------------
https://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices/samsung-arm-chromebook
http://linux-exynos.org/wiki/Samsung_Chromebook_XE303C12/Installing_Linux
http://archlinuxarm.org/platforms/armv7/samsung/samsung-chromebook
http://www.de7ec7ed.com/2013/05/application-processor-ap-uart-samsung.html
http://www.de7ec7ed.com/2013/05/embedded-controller-ec-uart-samsung.html
