################################################################################
#
# hidapi
#
################################################################################

# Use master version as the current stable is very old and some bugs
# have been fixed since then.
HIDAPI_VERSION = d17db57b9d4354752e0af42f5f33007a42ef2906
HIDAPI_SITE = $(call github,signal11,hidapi,$(HIDAPI_VERSION))
HIDAPI_INSTALL_STAGING = YES
# No configure provided, so we need to autoreconf.
HIDAPI_AUTORECONF = YES
HIDAPI_LICENSE = GPLv3 or BSD-3c or HIDAPI license
HIDAPI_LICENSE_FILES = LICENSE.txt LICENSE-gpl3.txt LICENSE-bsd.txt LICENSE-orig.txt

HIDAPI_DEPENDENCIES = libusb

ifeq ($(BR2_PACKAGE_LIBGUDEV),y)
HIDAPI_DEPENDENCIES += libgudev
endif

$(eval $(autotools-package))
