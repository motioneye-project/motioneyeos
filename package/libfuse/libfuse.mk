#############################################################
#
# libfuse
#
#############################################################

LIBFUSE_VERSION = 2.9.0
LIBFUSE_SOURCE = fuse-$(LIBFUSE_VERSION).tar.gz
LIBFUSE_SITE = http://downloads.sourceforge.net/project/fuse/fuse-2.X/$(LIBFUSE_VERSION)

LIBFUSE_INSTALL_STAGING = YES
LIBFUSE_CONF_OPT= --disable-nls \
		--disable-example \
		--disable-kernel-module \
		--enable-lib \
		--enable-util

define LIBFUSE_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/bin/fusermount $(TARGET_DIR)/usr/bin/
	cp -dpf $(STAGING_DIR)/usr/lib/libfuse.so* $(TARGET_DIR)/usr/lib/
endef

define LIBFUSE_CLEAN_CMDS
	-$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) uninstall
	-$(MAKE) -C $(@D) clean
	rm -f $(TARGET_DIR)/usr/bin/fusermount $(TARGET_DIR)/usr/lib/libfuse.so*
endef

$(eval $(autotools-package))
