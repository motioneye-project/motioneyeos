#############################################################
#
# openocd
#
#############################################################
OPENOCD_VERSION:=0.5.0
OPENOCD_SOURCE = openocd-$(OPENOCD_VERSION).tar.bz2
OPENOCD_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/project/openocd/openocd/$(OPENOCD_VERSION)

OPENOCD_AUTORECONF = YES
OPENOCD_CONF_OPT = \
	--oldincludedir=$(STAGING_DIR)/usr/include \
	--includedir=$(STAGING_DIR)/usr/include \
	--disable-doxygen-html \
	--enable-dummy

OPENOCD_DEPENDENCIES = libusb-compat

# Adapters
ifeq ($(BR2_PACKAGE_OPENOCD_FT2XXX),y)
OPENOCD_CONF_OPT += --enable-ft2232_libftdi
endif

ifeq ($(BR2_PACKAGE_OPENOCD_JLINK),y)
OPENOCD_CONF_OPT += --enable-jlink
endif

ifeq ($(BR2_PACKAGE_OPENOCD_VSLLINK),y)
OPENOCD_CONF_OPT += --enable-vsllink
endif

$(eval $(call AUTOTARGETS))
