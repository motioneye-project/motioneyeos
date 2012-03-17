This is the buildroot board support for the Avnet Spartan6 LX9 MicroBoard.

The Avnet S6LX9 Microboard is a small USB-Stick sized module containing
a Spartan6 FPGA capable of running the Microblaze softcore processor
together with RAM and FLASH memory.

The board can be bought from Avnet (avnet.com) or from Trenz Electronic
(www.trenz-electronic.de) for a low price.

To run the Linux built with buildroot you have to install the FPGA bitfile
and u-boot as described in the tutorial AvtS6LX9MicroBoard_SW302_PetaLinux
available on http://www.em.avnet.com/s6microboard

On this site also is a forum containing information on how to build your own
Microblaze processor for the Microboard.

The image file (default name is simpleImage.lx9_mmu.ub) has to be copied
to your tftp folder (often /tftpboot/) or can be programmed into the
board's SPI flash.

Sample session:

$ make s6lx9_microboard_defconfig
$ make
$ cp build/linux-<version>/arch/microblaze/boot/simpleImage.lx9_mmu.ub /tftpboot/br12.2a.ub
$ minicom
<hit the reset button on the S6LX9 Microboard>

                Icache:ON
                Dcache:ON
        U-Boot Start:0x83f00000
SF: Got idcode 20 ba 18 10 01
*** Warning - bad CRC, using default environment

Net:   Xilinx_Emaclite
MAC:   00:0a:35:00:63:37
U-BOOT for Avnet-LX9-Microboard-AXI-tiny-13.1

BOOTP broadcast 1
DHCP client bound to address 192.168.11.122
Hit any key to stop autoboot:  0
U-Boot-PetaLinux> tftp br12.2a.ub
Using Xilinx_Emaclite device
TFTP from server 192.168.11.10; our IP address is 192.168.11.122
Filename 'br12.2a.ub'.
Load address: 0x80002000
Loading: #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         ##############################
done
Bytes transferred = 5207724 (4f76ac hex)
U-Boot-PetaLinux> bootm
## Booting kernel from Legacy Image at 80002000 ...
   Image Name:   Linux-3.1.0
   Image Type:   MicroBlaze Linux Kernel Image (uncompressed)
   Data Size:    5207660 Bytes =  5 MB
   Load Address: 80000000
   Entry Point:  80000000
   Verifying Checksum ... OK
   Loading Kernel Image ... OK
OK
## Transferring control to Linux (at address 80000000), 0x80000000 ramdisk 0x00000000, FDT 0x00000000...
Early console on uartlite at 0x40600000
..... boot log skipped

Welcome to Microblaze Buildroot
Microblaze login:
