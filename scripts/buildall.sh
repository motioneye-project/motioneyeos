#!/bin/sh
# Should be copied to toplevel before it is run.
# An OK sttus indicates that it compiles for an arch.
# This has been tested on ARM and AVR32, status is for ARM
sed	-i s/^.*Config.in.test.*//	Config.in
echo	"source \"scripts/test/Config.in.test.$1\"" >> Config.in
sed	-i s/^.*BR2_TARGET_TEST_PACKAGES*//	.config
echo	"BR2_TARGET_TEST_PACKAGES=y" >> .config
#cat	scripts/test/noconfiguration.$1 >> .config
make 	oldconfig	> info.log 2>&1

source	"scripts/testheader.inc"
make	flush
skip	mk	busybox				DISABLED
bb	mk	bash	
bb	mk	bzip2	
bb	mk	coreutils	
bb	mk	diffutils	
bb	mk	findutils	
EXE	mk	flex				OK	
bb	mk	gawk	
bb	mk	grep	
EXE	mk	make				OK	
comment	# Other development stuff
EXE	mk	autoconf			OK	
EXE	mk	automake			OK	
EXE	mk	bison				OK	
EXE	mk	cvs				OK	
EXE	mk	distcc				OK	
EXE	mk	dmalloc				OK	
EXE	mk	fakeroot			OK	
EXE	mk	gettext				OK	
EXE	mk	libgmp				OK	
EXE	mk	gperf				OK	
EXE	mk	libmpfr				OK	
EXE	mk	libtool				OK	
EXE	mk	libiconv			OK	
EXE	mk	popt				OK	
EXE	mk	m4				OK	
skip	mk	mpatrol				DISABLED	"Needs gdb to build, and GDB_VERSION is not defined"	
EXE	mk	oprofile			FAIL		"error: bfd library not found"
EXE	mk	pkgconfig			OK	
EXE	mk	readline			OK	
skip	mk	valgrind			DISABLED	"x86 specific"	
EXE	mk	pcre				OK	
comment	Other stuff
EXE	mk	at				OK	
EXE	mk	beecrypt			OK	
AVR	mk	berkeleydb			OK		"Machine avr32 not recognized"
EXE	mk	bsdiff				OK	
bb	mk	bootutils	
EXE	mk	cups				OK	
EXE	mk	customize			OK	
bb	mk	dash	
EXE	mk	file				OK	
EXE	mk	gamin				OK	
EXE	mk	icu				OK	
AVR	mk	kexec				OK		"Machine avr32 not recognized"
bb	mk	less	
EXE	mk	libconfig			OK	
EXE	mk	libconfuse			OK	
EXE	mk	libdaemon			OK	
EXE	mk	libelf				OK	
AVR	mk	libevent			OK		"Machine avr32 not recognized"
skip	mk	libfloat			DISABLED	"Obsolete package"	
EXE	mk	libgcrypt			OK	
EXE	mk	libgpg-error			OK	
EXE	mk	liblockfile			OK	
EXE	mk	liboil				OK	
EXE	mk	libsysfs			OK	
EXE	mk	lockfile-progs			OK	
EXE	mk	logrotate			OK	
EXE	mk	lsof				OK	
skip	mk	ltp-testsuite			DISABLED
AVR	mk	ltrace				OK		"Machine avr32 not recognized"
skip	mk	ltt				DISABLED	"Obsolete package ltt-ng"	
EXE	mk	memstat				OK	
EXE	mk	module-init-tools		OK		"Use this instead of modutils"
skip	mk	modutils			DISABLED	"This package is for the Linux 2.4 kernel"	
EXE	mk	ng-spice-rework			FAIL		"Environment change"
bb	mk	procps	
bb	mk	psmisc	
EXE	mk	screen				OK	
EXE	mk	strace				OK	
EXE	mk	sudo				OK	
bb	mk	sysklogd	
comment	busybox has init and the runit stuff
bb	mk	sysvinit	
bb	mk	tinylogin	
bb	mk	util-linux	
bb	mk	which	
comment	database
EXE	mk	mysql_client			OK	
EXE	mk	sqlite				OK	
comment	editors
EXE	mk	ed				OK	
EXE	mk	nano				OK	
EXE	mk	uemacs				OK	
EXE	mk	vim				FAIL		"Cannot find source"	
comment	Networking applications
AVR	mk	argus				OK		"Machine avr32 not recognized"
EXE	mk	avahi				OK	
EXE	mk	axel				OK	
bb	mk	boa	
AVR	mk	bind				OK		"Machine avr32 not recognized"
EXE	mk	bridge				OK	
bb	mk	dhcp	
EXE	mk	dnsmasq				OK	
EXE	mk	dropbear			OK	
EXE	mk	ethtool				OK	
EXE	mk	haserl				OK	
skip	mk	hostap				DISABLED	"Needs PCMCIA in kernel"
EXE	mk	ifplugd				OK	
skip	mk	irda-utils			DISABLED	"Makefile is invalid"	
EXE	mk	iperf				OK	
EXE	mk	iproute2			OK	
EXE	mk	ipsec-tools			OK	
EXE	mk	iptables			OK	
AVR	mk	kismet				OK		"Machine avr32 not recognized"
EXE	mk	l2tp				OK	
EXE	mk	libcgi				OK	
EXE	mk	libcgicc			OK	
EXE	mk	libosip2			OK	
AVR	mk	libeXosip2			OK		"Machine avr32 not recognized"
EXE	mk	libpcap				OK	
EXE	mk	libupnp				OK	
bb	mk	lighttpd	
EXE	mk	links				OK	
EXE	mk	lrzsz				OK	
EXE	mk	mdnsresponder			OK	
bb	mk	microcom	
EXE	mk	mii-diag			OK	
EXE	mk	mrouted				OK	
EXE	mk	mutt				FAIL		"Compile Error" 
EXE	mk	nbd				OK	
EXE	mk	ncftp				OK	
EXE	mk	neon				OK	
bb	mk	netcat	
EXE	mk	netkitbase			OK	
EXE	mk	netkittelnet			OK	
EXE	mk	netplug				OK	
EXE	mk	netsnmp				OK	
EXE	mk	nfs-utils			OK	
EXE	mk	ntp				FAIL		""	
EXE	mk	olsr				OK	
AVR	mk	ntpd				OK		"Machine avr32 not recognized"
EXE	mk	openssh				OK	
EXE	mk	openssl				OK	
EXE	mk	libcurl				FAIL		"ELF file data encoding not little-endian"
AVR	mk	openvpn				OK		"Machine avr32 not recognized"
EXE	mk	openswan			FAIL		"Compile Error" 
EXE	mk	portmap				OK	
EXE	mk	pppd				OK	
EXE	mk	rp-pppoe			OK	
EXE	mk	pptp-linux			OK	
EXE	mk	proftpd				OK	
skip	mk	quagga				DISABLED
EXE	mk	rsync				OK	
EXE	mk	samba				OK	
EXE	mk	socat				OK	
AVR	mk	stunnel				OK		"Machine avr32 not recognized"
EXE	mk	tcpdump				OK	
EXE	mk	tftpd				OK	
bb	mk	thttpd	
bb	mk	tinyhttpd	
skip	mk	tn5250				DISABLED
EXE	mk	ttcp				OK	
bb	mk	udhcp	
EXE	mk	udpcast				OK	
EXE	mk	vpnc				OK	
EXE	mk	vsftpd				OK	
AVR	mk	vtun				OK		"Machine avr32 not recognized"
EXE	mk	webif				OK	
bb	mk	wget	
EXE	mk	wireless-tools			OK	
comment	Hardware handling / blockdevices and filesystem maintenance
EXE	mk	acpid				OK	
EXE	mk	dbus				OK	
AVR	mk	dbus-glib			OK		"Machine avr32 not recognized"
EXE	mk	devmem2				OK	
EXE	mk	dm				OK	
AVR	mk	dmraid				OK		"Machine avr32 not recognized"
EXE	mk	e2fsprogs			OK	
EXE	mk	eeprog				OK	
EXE	mk	fconfig				OK	
EXE	mk	fis				OK	
EXE	mk	libfuse				OK	
EXE	mk	gadgetfs-test			OK	
AVR	mk	hal				FAIL		"Machine avr32 not recognized"
bb	mk	hdparm	
bb	mk	hotplug	
EXE	mk	hwdata				OK	
EXE	mk	i2c-tools			OK	
EXE	mk	input-tools			OK	
EXE	mk	iostat				OK	
EXE	mk	libaio				OK	
skip	mk	libraw1394			DISABLED
EXE	mk	libusb				OK	
EXE	mk	lm-sensors			OK	
EXE	mk	lvm2				OK	
EXE	mk	mdadm				OK	
EXE	mk	memtester			OK	
EXE	mk	mkdosfs				OK	
EXE	mk	mtd				OK	
AVR	mk	ntfs-3g				OK		"Machine avr32 not recognized"
EXE	mk	pciutils			OK	
skip	mk	pcmcia				DISABLED
EXE	mk	setserial			OK	
bb	mk	sfdisk	
AVR	mk	smartmontools			OK		"Machine avr32 not recognized"
EXE	mk	usbmount			OK	
EXE	mk	usbutils			OK	
EXE	mk	wipe				OK	
skip	mk	xfsprogs			DISABLED
comment	Interpreter languages / Scripting
EXE	mk	lua				OK	
EXE	mk	microperl			OK	
EXE	mk	python				OK	
AVR	mk	ruby				FAIL		"can't find header files for ruby,Machine avr32 not recognized"
EXE	mk	tcl				FAIL		"cannot find definition of 'struct stat'; Need __XOPEN" 
EXE	mk	php				OK	
comment	text rendering applications
EXE	mk	dialog				OK	
comment	Audio and video libraries and applications
EXE	mk	alsa-lib			OK	
EXE	mk	alsa-utils			OK	
EXE	mk	asterisk			FAIL		"Patch fails"	
EXE	mk	aumix				OK	
EXE	mk	gstreamer			OK	
EXE	mk	gst-plugins-base		OK	
EXE	mk	gst-plugins-good		FAIL		"/usr/lib/libaa.so: could not read symbols: File in wrong format"
EXE	mk	gst-plugins-ugly		OK	
EXE	mk	libid3tag			OK	
EXE	mk	libmad				OK	
EXE	mk	libmpd				OK	
EXE	mk	libogg				OK	
EXE	mk	libsndfile			OK		"Error: operand out of range (AVR32 specific compile error)"
EXE	mk	libtheora			FAIL		"./vp3huff: cannot execute binary file"
EXE	mk	libvorbis			OK	
EXE	mk	madplay				OK	
EXE	mk	mpg123				OK	
EXE	mk	mplayer				OK	
EXE	mk	speex				OK	
EXE	mk	festival			FAIL		"undefined reference to EST_TokenStream"
EXE	mk	vlc				FAIL		"configure:Cannot find libmad library."
comment	Graphic libraries and applications (graphic/text)
comment	text rendering libraries
EXE	mk	ncurses				OK	
EXE	mk	newt				OK	
EXE	mk	slang				OK	
comment	graphic libraries
EXE	mk	directfb			OK	
EXE	mk	directfb-examples		OK	
EXE	mk	fbdump				OK	
EXE	mk	linux-fusion			OK	
EXE	mk	imagemagick			FAIL		"cannot run test program while cross compiling"
EXE	mk	jpeg				OK	
EXE	mk	libart				OK	
EXE	mk	libpng				OK	
EXE	mk	libungif			OK	
EXE	mk	lite				OK	
EXE	mk	pixman				OK	
EXE	mk	sawman				OK	
EXE	mk	sdl				OK	
EXE	mk	sdl_image			OK	
EXE	mk	sdl_mixer			OK	
EXE	mk	sdl_net				OK	
EXE	mk	sdl_ttf				OK	
EXE	mk	tiff				OK	
comment	busybox graphic applications
comment		--> May be broken in busybox
EXE	mk	fbv				OK	
EXE	mk	fbset				OK	
comment	other GUIs
SKIP
EXE	mk	qte				DISABLED
EXE	mk	qtopia4				DISABLED
EXE	mk	x11r7				DISABLED
RESTART
EXE	mk	atk				OK	
EXE	mk	cairo				OK	
EXE	mk	pango				OK	
EXE	mk	libdrm				OK	
EXE	mk	liberation			OK	
EXE	mk	libglade			OK	
EXE	mk	libglib12			OK	
EXE	mk	libglib2			OK	
EXE	mk	libgtk12			FAIL		"Depends on X11"	
EXE	mk	libgtk2				OK	
EXE	mk	gtk2-engines			OK	
EXE	mk	gtk2-theme-hicolour		FAIL		"Fails in dbus"	
EXE	mk	libsexy				OK	
EXE	mk	fltk				OK	
skip	mk	openmotif			DISABLED
RESTART
EXE	mk	fontconfig			OK	
EXE	mk	freetype			OK	
EXE	mk	tslib				OK	
SKIP
EXE	mk	webkit				
skip	mk	startup-notification		DISABLED	"Depends on X11"
comment	X Window managers
EXE	mk	matchbox			
EXE	mk	metacity			
EXE	mk	blackbox			
comment	X applications
EXE	mk	alsamixergui			
EXE	mk	dillo				
EXE	mk	docker				
EXE	mk	gqview				
EXE	mk	gmpc				
EXE	mk	gtkperf				
EXE	mk	leafpad				
EXE	mk	midori				
EXE	mk	pcmanfm				
EXE	mk	rdesktop			
EXE	mk	rxvt				
EXE	mk	sylpheed			
EXE	mk	synergy				
EXE	mk	torsmo				
EXE	mk	x11vnc				
EXE	mk	xpdf				
EXE	mk	xstroke				
EXE	mk	xvkbd				
RESTART
comment	Compressors / decompressors
EXE	mk	lzo				OK	
EXE	mk	lzma-host			OK	
EXE	mk	lzma-target			OK	
EXE	mk	zlib				OK	
comment	Package managers
EXE	mk	ipkg				OK	
EXE	mk	portage				OK	
comment	XML handling
EXE	mk	expat				OK	
EXE	mk	ezxml				OK	
EXE	mk	libxml2				OK	
EXE	mk	libxslt				OK	
AVR	mk	xerces				OK		"Machine avr32 not recognized"
skip	mk	java				DISABLED
skip	mk	games				DISABLED	
