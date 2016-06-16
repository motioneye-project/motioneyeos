################################################################################
#
# sstrip
#
################################################################################

SSTRIP_SITE = svn://svn.openwrt.org/openwrt/trunk/tools/sstrip
SSTRIP_VERSION = 20154

define SSTRIP_BUILD_CMDS
	cd $(@D) ; \
	$(TARGET_CC) $(TARGET_CFLAGS) -include endian.h -include byteswap.h \
		-o sstrip src/sstrip.c
endef

define SSTRIP_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/sstrip $(TARGET_DIR)/usr/bin/sstrip
endef

$(eval $(generic-package))
