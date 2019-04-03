################################################################################
#
# libcamera
#
################################################################################

LIBCAMERA_SITE = https://git.linuxtv.org/libcamera.git
LIBCAMERA_VERSION = d5ca33f6c7b0cd1ca20ec5dc7131aeedf1503080
LIBCAMERA_SITE_METHOD = git
LIBCAMERA_DEPENDENCIES = udev
LIBCAMERA_CONF_OPTS = -Dtests=false -Ddocumentation=false
LIBCAMERA_INSTALL_STAGING = yes
LIBCAMERA_LICENSE = LGPL-2.1+ (library), GPL-2.0+ (utils)
LIBCAMERA_LICENSE_FILES = \
	licenses/gnu-gpl-2.0.txt \
	licenses/gnu-lgpl-2.1.txt

$(eval $(meson-package))
