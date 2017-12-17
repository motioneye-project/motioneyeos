################################################################################
#
# hidapi
#
################################################################################

# Use master version as the current stable is very old and some bugs
# have been fixed since then.
HIDAPI_VERSION = b5b2e1779b6cd2edda3066bbbf0921a2d6b1c3c0
HIDAPI_SITE = $(call github,signal11,hidapi,$(HIDAPI_VERSION))
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
