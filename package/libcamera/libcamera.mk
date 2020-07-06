################################################################################
#
# libcamera
#
################################################################################

LIBCAMERA_SITE = https://git.linuxtv.org/libcamera.git
LIBCAMERA_VERSION = 448393f77ec9e37cb807e8e8d35c1a4877d253d4
LIBCAMERA_SITE_METHOD = git
LIBCAMERA_DEPENDENCIES = udev
LIBCAMERA_CONF_OPTS = -Dtest=false -Ddocumentation=false
LIBCAMERA_INSTALL_STAGING = YES
LIBCAMERA_LICENSE = LGPL-2.1+ (library), GPL-2.0+ (utils)
LIBCAMERA_LICENSE_FILES = \
	licenses/gnu-gpl-2.0.txt \
	licenses/gnu-lgpl-2.1.txt

$(eval $(meson-package))
