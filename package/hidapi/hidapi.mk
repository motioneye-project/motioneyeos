################################################################################
#
# hidapi
#
################################################################################

HIDAPI_VERSION = 0.9.0
HIDAPI_SITE = $(call github,libusb,hidapi,hidapi-$(HIDAPI_VERSION))
HIDAPI_INSTALL_STAGING = YES
# No configure provided, so we need to autoreconf.
HIDAPI_AUTORECONF = YES
HIDAPI_LICENSE = GPL-3.0 or BSD-3-Clause or HIDAPI license
HIDAPI_LICENSE_FILES = LICENSE.txt LICENSE-gpl3.txt LICENSE-bsd.txt LICENSE-orig.txt

HIDAPI_DEPENDENCIES = libusb libgudev

ifeq ($(BR2_PACKAGE_LIBICONV),y)
HIDAPI_DEPENDENCIES += libiconv
HIDAPI_CONF_ENV += LIBS="-liconv"
endif

$(eval $(autotools-package))
