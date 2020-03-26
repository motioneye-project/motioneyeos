if itest.s a$uboot_defconfig == a; then
        echo "Please set uboot_defconfig to the appropriate value"
        exit
fi

offset=0x400
erase_size=0xC0000
qspi_offset=0x0
a_base=0x12000000
block_size=0x200

if itest.s x51 == "x${imx_cpu}"; then
	a_base=0x92000000
elif itest.s x53 == "x${imx_cpu}"; then
	a_base=0x72000000
elif itest.s x6SX == "x${imx_cpu}" || itest.s x6ULL == "x${imx_cpu}" || itest.s x7D == "x${imx_cpu}"; then
	a_base=0x82000000
elif itest.s x8MQ == "x${imx_cpu}" || itest.s x8MM == "x${imx_cpu}" || itest.s x8MMQ == "x${imx_cpu}"; then
	a_base=0x42000000
	offset=0x8400
elif itest.s x8MNano == "x${imx_cpu}"; then
	a_base=0x42000000
	offset=0x8000
fi

qspi_match=1
setexpr a_qspi1 ${a_base}
setexpr a_qspi2 ${a_qspi1} + 0x400000
setexpr a_uImage1 ${a_qspi1} + 0x400
setexpr a_uImage2 ${a_qspi2} + 0x400
setexpr a_script ${a_base}

setenv stdout serial,vga

if itest.s "x${sfname}" == "x" ; then
# U-Boot resides in (e)MMC
if itest.s "x${env_dev}" == "x" || itest.s "x${env_part}" == "x"; then
        echo "Please set env_dev/part to the appropriate values"
        exit
fi

# Load bootloader binary for this board
if ${fs}load ${devtype} ${devnum}:${distro_bootpart} ${a_uImage1} u-boot.$uboot_defconfig ; then
else
	echo "File u-boot.$uboot_defconfig not found on SD card" ;
	exit
fi

# Compute block count for filesize and offset
setexpr cntoffset ${offset} / ${block_size}
setexpr cntfile ${filesize} / ${block_size}
# Add 1 in case the $filesize is not a multiple of $block_size
setexpr cntfile ${cntfile} + 1

# Select media partition (if different from main partition)
mmc dev ${env_dev} ${env_part}

# Read and compare current U-Boot
mmc read ${a_uImage2} ${cntoffset} ${cntfile}
if cmp.b ${a_uImage1} ${a_uImage2} ${filesize} ; then
	echo "------- U-Boot versions match" ;
	echo "------- U-Boot upgrade NOT needed" ;
	exit ;
fi

echo "Need U-Boot upgrade" ;
echo "Program in 5 seconds" ;
for n in 5 4 3 2 1 ; do
	echo $n ;
	sleep 1 ;
done
mmc write ${a_uImage1} ${cntoffset} ${cntfile}

# Make sure to boot from the proper partition
if itest ${env_part} != 0 ; then
	mmc partconf ${env_dev} 1 ${env_part} 0
fi

# Switch back to main eMMC partition (to avoid confusion)
mmc dev ${env_dev}

else
# U-Boot resides in NOR flash
if sf probe || sf probe || sf probe 1 27000000 || sf probe 1 27000000 ; then
	echo "probed SPI ROM" ;
else
	echo "Error initializing EEPROM"
	exit
fi

if itest.s "x${sfname}" == "xat45db041d" ; then
	erase_size=0x7e000
fi

if itest.s x7D == "x${imx_cpu}"; then
	echo "check qspi parameter block" ;
	if ${fs}load ${devtype} ${devnum}:${distro_bootpart} ${a_qspi1} qspi-${sfname}.${uboot_defconfig} ; then
	else
		echo "parameter file qspi-${sfname}.${uboot_defconfig} not found on SD card"
		exit
	fi
	if itest ${filesize} != 0x200 ; then
		echo "------- qspi-${sfname}.${uboot_defconfig} 0x${filesize} != 0x200 bytes" ;
		exit
	fi
	setexpr a_marker ${a_qspi1} + 0x1fc
	if itest *${a_marker} != c0ffee01 ; then
		echo "------- qspi-${sfname}.${uboot_defconfig} c0ffee01 marker missing" ;
		exit
	fi
	if sf read ${a_qspi2} ${qspi_offset} 0x200 ; then
	else
		echo "Error reading qspi parameter from EEPROM"
		exit
	fi
	if cmp.b ${a_qspi1} ${a_qspi2} 0x200 ; then
		echo "------- qspi parameters match"
	else
		echo "------- qspi parameters mismatch"
		qspi_match=0
	fi
fi

echo "check U-Boot" ;

if ${fs}load ${devtype} ${devnum}:${distro_bootpart} ${a_uImage1} u-boot.$uboot_defconfig ; then
else
	echo "File u-boot.$uboot_defconfig not found on SD card" ;
	exit
fi
echo "read $filesize bytes from SD card" ;
if sf read ${a_uImage2} $offset $filesize ; then
else
	echo "Error reading boot loader from EEPROM" ;
	exit
fi

if cmp.b ${a_uImage1} ${a_uImage2} $filesize ; then
	echo "------- U-Boot versions match" ;
	if itest.s "${qspi_match}" == "1" ; then
		echo "------- U-Boot upgrade NOT needed" ;
		if itest.s "x" != "x${next}" ; then
			if ${fs}load ${devtype} ${devnum}:${distro_bootpart} ${a_script} ${next} ; then
				source ${a_script}
			else
				echo "${next} not found on SD card"
			fi
		fi
		exit
	fi
	erase_size=0x1000
	if itest.s xMX25L6405D == "x${sfname}"; then
		erase_size=0x10000
	fi
	setexpr filesize ${erase_size} - ${offset}
fi

echo "Need U-Boot upgrade" ;
echo "Program in 5 seconds" ;
for n in 5 4 3 2 1 ; do
	echo $n ;
	sleep 1 ;
done
echo "erasing" ;
sf erase 0 ${erase_size} ;

# two steps to prevent bricking
echo "programming" ;
setexpr a1 ${a_uImage1} + 0x400
setexpr o1 ${offset} + 0x400
setexpr s1 ${filesize} - 0x400
sf write ${a1} ${o1} ${s1} ;
sf write ${a_uImage1} $offset 0x400 ;

if itest.s x7D == "x${imx_cpu}"; then
	sf write ${a_qspi1} ${qspi_offset} 0x200
fi

echo "verifying" ;
if sf read ${a_uImage2} $offset $filesize ; then
else
	echo "Error re-reading EEPROM" ;
	exit
fi
if cmp.b ${a_uImage1} ${a_uImage2} $filesize ; then
else
	echo "Read verification error" ;
	exit
fi

if itest.s x7D == "x${imx_cpu}"; then
	if sf read ${a_qspi2} ${qspi_offset} 0x200 ; then
	else
		echo "Error re-reading qspi" ;
		exit
	fi
	if cmp.b ${a_qspi1} ${a_qspi2} 0x200 ; then
	else
		echo "qspi parameter block verification error" ;
		exit
	fi
fi

if itest.s "x" != "x${next}" ; then
	if ${fs}load ${devtype} ${devnum}:${distro_bootpart} ${a_script} ${next} ; then
		source ${a_script}
	else
		echo "${next} not found on ${devtype} ${devnum}:${distro_bootpart}"
	fi
fi
fi

if itest.s "xno" == "x${reset}" ; then
	while echo "---- U-Boot upgraded. Please reset the board" ; do
		sleep 120
	done
fi
echo "---- U-Boot upgraded. The board will now reset."
sleep 1
reset
done
