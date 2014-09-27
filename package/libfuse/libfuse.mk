################################################################################
#
# libfuse
#
################################################################################

LIBFUSE_VERSION = 2.9.3
LIBFUSE_SOURCE = fuse-$(LIBFUSE_VERSION).tar.gz
LIBFUSE_SITE = http://downloads.sourceforge.net/project/fuse/fuse-2.X/$(LIBFUSE_VERSION)
LIBFUSE_LICENSE = GPLv2 LGPLv2.1
LIBFUSE_LICENSE_FILES = COPYING COPYING.LIB
LIBFUSE_INSTALL_STAGING = YES
LIBFUSE_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBICONV),libiconv)
LIBFUSE_CONF_OPTS = \
		--disable-example \
		--enable-lib \
		--enable-util

define LIBFUSE_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/bin/fusermount $(TARGET_DIR)/usr/bin/
	cp -dpf $(STAGING_DIR)/usr/lib/libfuse.so* $(TARGET_DIR)/usr/lib/
endef

$(eval $(autotools-package))
