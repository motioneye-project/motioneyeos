################################################################################
#
# libcamera
#
################################################################################

LIBCAMERA_SITE = https://git.linuxtv.org/libcamera.git
LIBCAMERA_VERSION = caf25dc5cfd11b965316f02610d49ae3d886716b
LIBCAMERA_SITE_METHOD = git
LIBCAMERA_DEPENDENCIES = udev
LIBCAMERA_CONF_OPTS = -Dtests=false -Ddocumentation=false
LIBCAMERA_INSTALL_STAGING = yes
LIBCAMERA_LICENSE = LGPL-2.1+ (library), GPL-2.0+ (utils)
LIBCAMERA_LICENSE_FILES = \
	licenses/gnu-gpl-2.0.txt \
	licenses/gnu-lgpl-2.1.txt

$(eval $(meson-package))
