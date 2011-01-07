#############################################################
#
# libfuse
#
#############################################################

LIBFUSE_VERSION = 2.8.5
LIBFUSE_SOURCE = fuse-$(LIBFUSE_VERSION).tar.gz
LIBFUSE_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/fuse/

LIBFUSE_INSTALL_STAGING = YES
LIBFUSE_CONF_OPT= --program-prefix="" \
		--enable-shared \
		--enable-static \
		--disable-nls \
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

$(eval $(call AUTOTARGETS,package,libfuse))
