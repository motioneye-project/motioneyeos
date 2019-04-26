################################################################################
#
# libcamera
#
################################################################################

LIBCAMERA_SITE = https://git.linuxtv.org/libcamera.git
LIBCAMERA_VERSION = ab0188fc8bbb6f397ac3aa11c9377662b7bd88b0
LIBCAMERA_SITE_METHOD = git
LIBCAMERA_DEPENDENCIES = udev
LIBCAMERA_CONF_OPTS = -Dtests=false -Ddocumentation=false
LIBCAMERA_INSTALL_STAGING = yes
LIBCAMERA_LICENSE = LGPL-2.1+ (library), GPL-2.0+ (utils)
LIBCAMERA_LICENSE_FILES = \
	licenses/gnu-gpl-2.0.txt \
	licenses/gnu-lgpl-2.1.txt

$(eval $(meson-package))
