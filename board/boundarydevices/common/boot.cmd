setenv bootargs ''

setenv initrd_high 0xffffffff
m4=''
a_base=0x10000000
if itest.s x51 == "x${imx_cpu}" ; then
	a_base=0x90000000
elif itest.s x53 == "x${imx_cpu}"; then
	a_base=0x70000000
elif itest.s x6SX == "x${imx_cpu}" || itest.s x7D == "x${imx_cpu}"; then
	a_base=0x80000000
	if itest.s "x1" == "x$m4enabled" ; then
		run m4boot;
		m4='-m4';
	fi
fi

setexpr a_script  ${a_base} + 0x00800000
setexpr a_zImage  ${a_base} + 0x00800000
setexpr a_fdt     ${a_base} + 0x03000000
setexpr a_ramdisk ${a_base} + 0x03800000
setexpr a_initrd  ${a_base} + 0x03a00000
setexpr a_reset_cause_marker ${a_base} + 0x80
setexpr a_reset_cause	     ${a_base} + 0x84

if itest.s "x" == "x${board}" ; then
	echo "!!!! Error: Your u-boot is outdated. Please upgrade.";
	exit;
fi

if itest.s "x" == "x${fdt_file}" ; then
	if itest.s x6SOLO == "x${imx_cpu}" ; then
		fdt_file=imx6dl-${board}.dtb;
	elif itest.s x6DL == "x${imx_cpu}" ; then
		fdt_file=imx6dl-${board}.dtb;
	elif itest.s x6QP == "x${imx_cpu}" ; then
		fdt_file=imx6qp-${board}.dtb;
	elif itest.s x6SX == "x${imx_cpu}" ; then
		fdt_file=imx6sx-${board}${m4}.dtb;
	elif itest.s x7D == "x${imx_cpu}" ; then
		fdt_file=imx7d-${board}${m4}.dtb;
	elif itest.s x51 == "x${imx_cpu}" ; then
		fdt_file=imx51-${board}${m4}.dtb;
	elif itest.s x53 == "x${imx_cpu}" ; then
		fdt_file=imx53-${board}${m4}.dtb;
	else
		fdt_file=imx6q-${board}.dtb;
	fi
fi

if itest.s x${distro_bootpart} == x ; then
	distro_bootpart=1
fi

if load ${devtype} ${devnum}:${distro_bootpart} ${a_script} uEnv.txt ; then
    env import -t ${a_script} ${filesize}
fi

setenv bootargs ${bootargs} console=${console},115200 vmalloc=400M consoleblank=0 rootwait fixrtc cpu=${imx_cpu} board=${board}

if load ${devtype} ${devnum}:${distro_bootpart} ${a_fdt} ${prefix}${fdt_file} ; then
	fdt addr ${a_fdt}
	setenv fdt_high 0xffffffff
else
	echo "!!!! Error loading ${prefix}${fdt_file}";
	exit;
fi

cmd_xxx_present=
fdt resize
if itest.s "x" != "x${cmd_custom}" ; then
	run cmd_custom
	cmd_xxx_present=1;
fi

if itest.s "x" != "x${cmd_hdmi}" ; then
	run cmd_hdmi
	cmd_xxx_present=1;
	if itest.s x == x${allow_noncea} ; then
		setenv bootargs ${bootargs} mxc_hdmi.only_cea=1;
		echo "only CEA modes allowed on HDMI port";
	else
		setenv bootargs ${bootargs} mxc_hdmi.only_cea=0;
		echo "non-CEA modes allowed on HDMI, audio may be affected";
	fi
fi

if itest.s "x" != "x${cmd_lcd}" ; then
	run cmd_lcd
	cmd_xxx_present=1;
fi
if itest.s "x" != "x${cmd_lcd2}" ; then
	run cmd_lcd2
	cmd_xxx_present=1;
fi
if itest.s "x" != "x${cmd_lvds}" ; then
	run cmd_lvds
	cmd_xxx_present=1;
fi
if itest.s "x" != "x${cmd_lvds2}" ; then
	run cmd_lvds2
	cmd_xxx_present=1;
fi

if itest.s "x" == "x${cmd_xxx_present}" ; then
	echo "!!!!!!!!!!!!!!!!"
	echo "warning: your u-boot may be outdated, please upgrade"
	echo "!!!!!!!!!!!!!!!!"
fi

if test "sata" = "${devtype}" ; then
	setenv bootargs "${bootargs} root=/dev/sda${distro_bootpart}" ;
elif test "usb" = "${devtype}" ; then
	setenv bootargs "${bootargs} root=/dev/sda${distro_bootpart}" ;
else
	setenv bootargs "${bootargs} root=/dev/mmcblk${devnum}p${distro_bootpart}"
fi

if itest.s "x" != "x${disable_msi}" ; then
	setenv bootargs ${bootargs} pci=nomsi
fi;

if itest.s "x" != "x${disable_giga}" ; then
	setenv bootargs ${bootargs} fec.disable_giga=1
fi

if itest.s "x" != "x${wlmac}" ; then
	setenv bootargs ${bootargs} wlcore.mac=${wlmac}
	setenv bootargs ${bootargs} wlan.mac=${wlmac}
fi

if itest.s "x" != "x${gpumem}" ; then
	setenv bootargs ${bootargs} galcore.contiguousSize=${gpumem}
fi

if itest.s "x" != "x${cma}" ; then
	setenv bootargs ${bootargs} cma=${cma}
fi

if itest.s "x" != "x${loglevel}" ; then
	setenv bootargs ${bootargs} loglevel=${loglevel}
fi

if itest.s "x" != "x${show_fdt}" ; then
	fdt print /
fi

if itest.s "x" != "x${show_env}" ; then
	printenv
fi

if load ${devtype} ${devnum}:${distro_bootpart} ${a_zImage} ${prefix}zImage ; then
	bootz ${a_zImage} - ${a_fdt}
fi
echo "Error loading kernel image"
