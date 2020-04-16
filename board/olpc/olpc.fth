\ OLPC XO boot script

: (visible)  " unfreeze visible" evaluate  ;
' (visible) catch  drop  forget (visible)

" /aliases" find-device " last" get-property
abort" No last alias"
" /pci/sd@c"          2over substring?  if  " root=/dev/mmcblk0p1 " to boot-file  then
" /sd/sdhci@d4280000" 2over substring?  if  " root=/dev/mmcblk1p1 " to boot-file  then
" /pci/usb@"          2over substring?  if  " root=/dev/sda1 "      to boot-file  then
" /usb@"              2over substring?  if  " root=/dev/sda1 "      to boot-file  then
2drop

root-device " compatible" get-property dend  if  0 0  then  ( compatible$ )
" olpc,xo-1.75" 2over sindex -1 > if  ( compatible$ )
   \ Version check on XO-1.75
   " mrvl,mmp2" 2over sindex -1 =  if ( compatible$ )
      2drop                           ( )
      cr
      ." Firmware Q4E00 or newer is needed to boot a Devicetree enabled kernel." cr
      cr
      ." One way to update is to copy http://dev.laptop.org/~quozl/q4e00ja.rom" cr
      ." to a FAT partition on a USB flash stick and run ""flash u:\q4e00ja.rom""" cr
      cr
      ." Aborting boot." cr
      " show-sad" evaluate
      abort
   then
then ( compatible$ )

" mmp" 2swap sindex -1 > if
   \ A Marvell MMP-based machine
   " last:\boot\zImage" to boot-device
   boot-file " console=ttyS2,115200 " $cat2 to boot-file
else
    \ Assume XO-1
   " last:\boot\bzImage" to boot-device
   boot-file " console=ttyS0,115200 reboot=pci " $cat2 to boot-file
then

\ Pick a terminal that looks better on the XO screen
root-device " architecture" get-property dend  if  0 0  else  1-  then
" OLPC" $=  if  boot-file " fbcon=font:TER16x32 vt.color=0xf0 " $cat2 to boot-file  then

boot-file " console=tty0 rootwait" $cat2 to boot-file
boot
