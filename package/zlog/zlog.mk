################################################################################
#
# zlog
#
################################################################################

ZLOG_VERSION = ca6162be1608839e99c6388c28488c51ccf98e4a
ZLOG_SITE = $(call github,HardySimpson,zlog,$(ZLOG_VERSION))
ZLOG_LICENSE = LGPLv2.1
ZLOG_LICENSE_FILES = COPYING
ZLOG_INSTALL_STAGING = YES

define ZLOG_BUILD_CMDS
	$(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D) all
endef

define ZLOG_INSTALL_STAGING_CMDS
	$(MAKE) PREFIX=$(STAGING_DIR)/usr -C $(@D) install
endef

define ZLOG_INSTALL_TARGET_CMDS
	$(MAKE) PREFIX=$(TARGET_DIR)/usr -C $(@D) install
endef

$(eval $(generic-package))
