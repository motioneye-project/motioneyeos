################################################################################
#
# sstrip
#
################################################################################

SSTRIP_SITE = svn://dev.openwrt.org/openwrt/trunk/tools/sstrip
SSTRIP_VERSION = 20154
HOST_SSTRIP_BINARY = $(GNU_TARGET_NAME)-sstrip

# This is a kludge to get host-ccache built before us or it fails
ifeq ($(BR2_CCACHE),y)
HOST_SSTRIP_DEPENDENCIES = host-ccache
endif

define SSTRIP_BUILD_CMDS
	cd $(@D) ; \
	$(TARGET_CC) $(TARGET_CFLAGS) -include endian.h -include byteswap.h \
		-o sstrip src/sstrip.c
endef

define SSTRIP_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/sstrip $(TARGET_DIR)/usr/bin/sstrip
endef

define SSTRIP_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/sstrip
endef

define HOST_SSTRIP_BUILD_CMDS
	cd $(@D) ; \
	$(HOSTCC) $(HOST_CFLAGS) -include endian.h -include byteswap.h \
		-o sstrip src/sstrip.c
endef

define HOST_SSTRIP_INSTALL_CMDS
	$(INSTALL) -D $(@D)/sstrip $(HOST_DIR)/usr/bin/$(HOST_SSTRIP_BINARY)
endef

define HOST_SSTRIP_UNINSTALL_CMDS
	rm -f $(HOST_DIR)/usr/bin/$(HOST_SSTRIP_BINARY)
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
