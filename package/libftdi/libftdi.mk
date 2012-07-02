#############################################################
#
# libftdi
#
#############################################################
LIBFTDI_VERSION = 0.19
LIBFTDI_SOURCE = libftdi-$(LIBFTDI_VERSION).tar.gz
LIBFTDI_SITE = http://www.intra2net.com/en/developer/libftdi/download/
LIBFTDI_DEPENDENCIES = libusb-compat libusb
LIBFTDI_INSTALL_STAGING = YES

LIBFTDI_AUTORECONF = YES

LIBFDTI_CONF_OPT = --without-examples

# configure detect it automaticaly so we need to force it
ifeq ($(BR2_PACKAGE_LIBTFDI_CPP),y)
LIBFDTI_CONF_OPT += --enable-libftdipp
else
LIBFDTI_CONF_OPT += --disable-libftdipp
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
