################################################################################
#
# libfuse3
#
################################################################################

LIBFUSE3_VERSION = 3.9.1
LIBFUSE3_SITE = $(call github,libfuse,libfuse,fuse-$(LIBFUSE3_VERSION))
LIBFUSE3_LICENSE = LGPL-2.1
LIBFUSE3_LICENSE_FILES = LICENSE
LIBFUSE3_INSTALL_STAGING = YES
LIBFUSE3_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBICONV),libiconv)
LIBFUSE3_CONF_OPTS = \
	-Dexamples=false \
	-Dudevrulesdir=/lib/udev/rules.d \
	-Duseroot=false

define LIBFUSE3_DEVICES
	/dev/fuse  c  666  0  0  10  229  0  0  -
endef

define LIBFUSE3_PERMISSIONS
	/usr/bin/fusermount3 f 4755 0 0 - - - - -
endef

$(eval $(meson-package))
