################################################################################
#
# libfuse
#
################################################################################

LIBFUSE_VERSION = 2.9.8
LIBFUSE_SOURCE = fuse-$(LIBFUSE_VERSION).tar.gz
LIBFUSE_SITE = https://github.com/libfuse/libfuse/releases/download/fuse-$(LIBFUSE_VERSION)
LIBFUSE_LICENSE = GPL-2.0, LGPL-2.1
LIBFUSE_LICENSE_FILES = COPYING COPYING.LIB
LIBFUSE_INSTALL_STAGING = YES
LIBFUSE_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBICONV),libiconv)
LIBFUSE_CONF_OPTS = \
	--disable-example \
	--enable-lib \
	--enable-util \
	UDEV_RULES_PATH=/lib/udev/rules.d

define LIBFUSE_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/bin/fusermount $(TARGET_DIR)/usr/bin/
	cp -dpf $(STAGING_DIR)/usr/lib/libfuse.so* $(TARGET_DIR)/usr/lib/
	mkdir -p $(TARGET_DIR)/lib/udev/rules.d
	cp $(STAGING_DIR)/lib/udev/rules.d/*-fuse.rules $(TARGET_DIR)/lib/udev/rules.d
endef

define LIBFUSE_DEVICES
	/dev/fuse  c  666  0  0  10  229  0  0  -
endef

define LIBFUSE_PERMISSIONS
	/usr/bin/fusermount f 4755 0 0 - - - - -
endef

$(eval $(autotools-package))
