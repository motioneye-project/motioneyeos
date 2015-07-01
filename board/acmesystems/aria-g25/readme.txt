Build instructions
==================

As a regular user configure and then build:

$ make acmesystems_aria_g25_128mb_defconfig (128MB RAM variant)
  or...
$ make acmesystems_aria_g25_256mb_defconfig (256MB RAM variant)

$ make

Writing to the MicroSD card
===========================

Assuming your Aria G25 baseboard has a MicroSD socket, for example with
the Terra baseboard, you'll need a blank MicroSD (obviously) initialized
in a particular way to be able to boot from it.

Assuming the card is seen as /dev/sdb in your PC/laptop/other device
you'll need to run the following commands as root or via sudo.

Make sure all of the card partitions are unmounted before starting.

First we'll need to create two partitions:

# sfdisk -uM /dev/sdb <<EOF
,32,6
;
EOF

Then we'll need to create the empty filesystems:

# mkdosfs -n SD_BOOT /dev/sdb1
# mkfs.ext4 -L SD_ROOT /dev/sdb2

We'll populate the first partition (boot) with the relevant files:

# mount /dev/sdb1 /mnt
# cp output/images/at91bootstrap.bin /mnt/BOOT.BIN
# cp output/images/zImage /mnt
# cp output/images/at91-ariag25.dtb /mnt
# umount /mnt

And the root filesystem afterwards:

# mount /dev/sdb2 /mnt
# tar -C /mnt output/images/rootfs.tar
# umount /mnt

You're done, insert the MicroSD card in the slot and enjoy.

