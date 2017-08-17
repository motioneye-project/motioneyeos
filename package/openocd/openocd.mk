################################################################################
#
# openocd
#
################################################################################

OPENOCD_VERSION = 0.10.0
OPENOCD_SOURCE = openocd-$(OPENOCD_VERSION).tar.bz2
OPENOCD_SITE = http://sourceforge.net/projects/openocd/files/openocd/$(OPENOCD_VERSION)
OPENOCD_LICENSE = GPL-2.0+
OPENOCD_LICENSE_FILES = COPYING
# 0002-configure-enable-build-on-uclinux.patch patches configure.ac
OPENOCD_AUTORECONF = YES
OPENOCD_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -std=gnu99"

OPENOCD_CONF_OPTS = \
	--oldincludedir=$(STAGING_DIR)/usr/include \
	--includedir=$(STAGING_DIR)/usr/include \
	--disable-doxygen-html \
	--with-jim-shared=no \
	--disable-shared \
	--enable-dummy \
	--disable-werror

# Rely on the Config.in options of each individual adapter selecting
# the dependencies they need.

OPENOCD_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_LIBFTDI1),libftdi1) \
	$(if $(BR2_PACKAGE_LIBUSB),libusb) \
	$(if $(BR2_PACKAGE_LIBUSB_COMPAT),libusb-compat) \
	$(if $(BR2_PACKAGE_LIBHID),libhid)

# Adapters
OPENOCD_CONF_OPTS += \
	$(if $(BR2_PACKAGE_OPENOCD_FTDI),--enable-ftdi,--disable-ftdi) \
	$(if $(BR2_PACKAGE_OPENOCD_STLINK),--enable-stlink,--disable-stlink) \
	$(if $(BR2_PACKAGE_OPENOCD_TI_ICDI),--enable-ti-icdi,--disable-ti-icdi) \
	$(if $(BR2_PACKAGE_OPENOCD_ULINK),--enable-ulink,--disable-ulink) \
	$(if $(BR2_PACKAGE_OPENOCD_UBLASTER2),--enable-usb-blaster-2,--disable-usb-blaster-2) \
	$(if $(BR2_PACKAGE_OPENOCD_JLINK),--enable-jlink,--disable-jlink) \
	$(if $(BR2_PACKAGE_OPENOCD_OSDBM),--enable-osbdm,--disable-osbdm) \
	$(if $(BR2_PACKAGE_OPENOCD_OPENDOUS),--enable-opendous,--disable-opendous) \
	$(if $(BR2_PACKAGE_OPENOCD_AICE),--enable-aice,--disable-aice) \
	$(if $(BR2_PACKAGE_OPENOCD_VSLLINK),--enable-vsllink,--disable-vsllink) \
	$(if $(BR2_PACKAGE_OPENOCD_USBPROG),--enable-usbprog,--disable-usbprog) \
	$(if $(BR2_PACKAGE_OPENOCD_RLINK),--enable-rlink,--disable-rlink) \
	$(if $(BR2_PACKAGE_OPENOCD_ARMEW),--enable-armjtagew,--disable-armjtagew) \
	$(if $(BR2_PACKAGE_OPENOCD_CMSIS_DAP),--enable-cmsis-dap,--disable-cmsis-dap) \
	$(if $(BR2_PACKAGE_OPENOCD_PARPORT),--enable-parport,--disable-parport) \
	$(if $(BR2_PACKAGE_OPENOCD_VPI),--enable-jtag_vpi,--disable-jtag_vpi) \
	$(if $(BR2_PACKAGE_OPENOCD_UBLASTER),--enable-usb-blaster,--disable-usb-blaster) \
	$(if $(BR2_PACKAGE_OPENOCD_AMTJT),--enable-amtjtagaccel,--disable-amjtagaccel) \
	$(if $(BR2_PACKAGE_OPENOCD_ZY1000_MASTER),--enable-zy1000-master,--disable-zy1000-master) \
	$(if $(BR2_PACKAGE_OPENOCD_ZY1000),--enable-zy1000,--disable-zy1000) \
	$(if $(BR2_PACKAGE_OPENOCD_EP93XX),--enable-ep93xx,--disable-ep93xx) \
	$(if $(BR2_PACKAGE_OPENOCD_AT91RM),--enable-at91rm9200,--disable-at91rm9200) \
	$(if $(BR2_PACKAGE_OPENOCD_BCM2835),--enable-bcm2835gpio,--disable-bcm2835gpio) \
	$(if $(BR2_PACKAGE_OPENOCD_GW16012),--enable-gw16012,--disable-gw16012) \
	$(if $(BR2_PACKAGE_OPENOCD_PRESTO),--enable-presto,--disable-presto) \
	$(if $(BR2_PACKAGE_OPENOCD_OPENJTAG),--enable-openjtag,--disable-openjtag) \
	$(if $(BR2_PACKAGE_OPENOCD_BUSPIRATE),--enable-buspirate,--disable-buspirate) \
	$(if $(BR2_PACKAGE_OPENOCD_SYSFS),--enable-sysfsgpio,--disable-sysfsgpio)

# Enable all configuration options for host build.
#
# Note that deprecated options have been removed. CMSIS_DAP needs
# hidapi (currently not included in buildroot) and zy1000 stuff fails
# to build, so they've been removed too.
#
HOST_OPENOCD_CONF_OPTS = \
	--enable-ftdi \
	--enable-stlink \
	--enable-ti-icdi \
	--enable-ulink \
	--enable-usb-blaster-2 \
	--enable-jlink \
	--enable-osbdm \
	--enable-opendous \
	--enable-aice \
	--enable-vsllink \
	--enable-usbprog \
	--enable-rlink \
	--enable-armjtagew \
	--enable-parport \
	--enable-jtag_vpi \
	--enable-usb-blaster \
	--enable-amtjtagaccel \
	--enable-gw16012 \
	--enable-presto \
	--enable-openjtag \
	--enable-buspirate \
	--enable-sysfsgpio \
	--oldincludedir=$(HOST_DIR)/include \
	--includedir=$(HOST_DIR)/include \
	--disable-doxygen-html \
	--with-jim-shared=no \
	--disable-shared \
	--enable-dummy \
	--disable-werror

HOST_OPENOCD_DEPENDENCIES = host-libftdi host-libusb host-libusb-compat

# Avoid documentation rebuild. On PowerPC64(le), we patch the
# configure script. Due to this, the version.texi files gets
# regenerated, and then since it has a newer date than openocd.info,
# openocd build system rebuilds the documentation. Unfortunately, this
# documentation rebuild fails on old machines. We work around this by
# faking the date of the generated version.texi file, to make the
# build system believe the documentation doesn't need to be
# regenerated.
define OPENOCD_FIX_VERSION_TEXI
	touch -r $(@D)/doc/openocd.info $(@D)/doc/version.texi
endef
OPENOCD_POST_BUILD_HOOKS += OPENOCD_FIX_VERSION_TEXI
HOST_OPENOCD_POST_BUILD_HOOKS += OPENOCD_FIX_VERSION_TEXI

$(eval $(autotools-package))
$(eval $(host-autotools-package))
