#############################################################
#
# libhid
#
#############################################################

LIBHID_VERSION = 0.2.16
LIBHID_SOURCE = libhid-$(LIBHID_VERSION).tar.gz
LIBHID_SITE = http://alioth.debian.org/frs/download.php/1958
LIBHID_DEPENDENCIES = libusb-compat libusb
LIBHID_INSTALL_STAGING = YES
# configure runs libusb-config for cflags/ldflags. Ensure it picks up
# the target version
LIBHID_CONF_ENV = PATH=$(STAGING_DIR)/usr/bin:$(TARGET_PATH)
LIBHID_CONF_OPT = \
	--disable-swig \
	--disable-werror \
	--without-doxygen \
	--disable-package-config

$(eval $(autotools-package))
