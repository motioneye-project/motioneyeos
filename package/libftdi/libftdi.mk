################################################################################
#
# libftdi
#
################################################################################

LIBFTDI_VERSION = 0.20
LIBFTDI_SITE = http://www.intra2net.com/en/developer/libftdi/download
LIBFTDI_DEPENDENCIES = libusb-compat libusb
LIBFTDI_INSTALL_STAGING = YES
LIBFTDI_CONFIG_SCRIPTS = libftdi-config
LIBFTDI_AUTORECONF = YES

LIBFDTI_CONF_OPTS = --without-examples

# configure detect it automaticaly so we need to force it
ifeq ($(BR2_PACKAGE_LIBTFDI_CPP),y)
LIBFTDI_DEPENDENCIES += boost
LIBFDTI_CONF_OPTS += --enable-libftdipp
else
LIBFDTI_CONF_OPTS += --disable-libftdipp
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
