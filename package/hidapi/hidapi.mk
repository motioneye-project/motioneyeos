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

# When eudev is used as the udev provider, libgudev is automatically
# provided as it is part of eudev. However, when systemd is used as
# the udev provider, libgudev is not provided, and needs to be built
# separately. This is why we depend on the libgudev package only if
# systemd is used.
ifeq ($(BR2_INIT_SYSTEMD),y)
HIDAPI_DEPENDENCIES += libgudev
endif

$(eval $(autotools-package))
