**************************************
Freescale i.MX31 PDK development board
**************************************

This file documents the Buildroot support for the Freescale i.MX31 PDK in "3
stack" configuration.

The i.MX31 Product Development Kit (or PDK) is Freescale development board [1]
based on the i.MX31 application processor [2].

For more details on the i.MX31 PDK board, refer to the User's Guide [3].

Build
=====

First, configure Buildroot for your i.MX31 PDK board:

  make freescale_imx31_3stack_defconfig

Build all components:

  make

You will find in ./output/images/ the following files:
  - rootfs.cpio
  - rootfs.cpio.gz
  - rootfs.tar
  - zImage

The generated zImage does include the rootfs.

Boot the PDK board
==================

The i.MX31 PDK contains a RedBoot bootloader in flash, which can be used to
boot the newly created Buildroot images from the network.

This necessitates to setup a TFTP server first. This setup is explained for
example in Freescale i.MX31 PDK 1.5 Linux User's Guide [4].

Here is a sample RedBoot configuration, for proper network boot of Buildroot on
the i.MX31 PDK:

    RedBoot> fconfig -l
    Run script at boot: true
    Boot script:
    .. load -r -b 0x100000 zImage
    .. exec -c "console=ttymxc0,115200"

    Boot script timeout (1000ms resolution): 2
    Use BOOTP for network configuration: false
    Gateway IP address: <your gateway IP address>
    Local IP address: <your PDK IP address>
    Local IP address mask: 255.255.255.0
    Default server IP address: <your TFTP server IP address>
    Board specifics: 0
    Console baud rate: 115200
    Set eth0 network hardware address [MAC]: false
    GDB connection port: 9000
    Force console for special debug messages: false
    Network debug at boot time: false

Adapt those settings to your network configuration by replacing the appropriate
network addresses where necessary.

You might want to verify that your i.MX31 PDK switches settings are the correct
ones for UART, power, boot mode, etc. Here is a reference switches
configuration:

    SW4
    1   2   3   4   5   6   7  8
    ON off off off off off off ON

    SW5 SW6 SW7 SW8 SW9 SW10
     0   1   0   0   0    0

See the i.MX31 PDK Linux Quick Start Guide [5] for more details on the switches
settings.

Connect a serial terminal set to 115200n8 and power on the i.MX31 PDK board.
Buildroot will present a login prompt on the serial port.

Enjoy!

References
==========

[1] http://www.freescale.com/webapp/sps/site/prod_summary.jsp?code=i.MX31PDK
[2] http://www.freescale.com/webapp/sps/site/prod_summary.jsp?code=i.MX31
[3] http://cache.freescale.com/files/32bit/doc/user_guide/pdk15_imx31_Hardware_UG.pdf
[4] http://cache.freescale.com/files/32bit/doc/support_info/IMX31_PDK15_LINUXDOCS_BUNDLE.zip, pdk15_imx31__Linux_UG.pdf
[5] http://www.freescale.com/files/32bit/doc/quick_ref_guide/PDK14LINUXQUICKSTART.pdf
