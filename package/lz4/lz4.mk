################################################################################
#
# lz4
#
################################################################################

LZ4_VERSION = r123
LZ4_SITE = $(call github,Cyan4973,lz4,$(LZ4_VERSION))
LZ4_INSTALL_STAGING = YES
LZ4_LICENSE = BSD-2c
LZ4_LICENSE_FILES = LICENSE

ifeq ($(BR2_STATIC_LIBS),y)
define LZ4_DISABLE_SHARED
	$(SED) '/SHARED/d' $(@D)/Makefile
endef
LZ4_POST_PATCH_HOOKS += LZ4_DISABLE_SHARED
endif

define HOST_LZ4_BUILD_CMDS
	$(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D)
endef

define HOST_LZ4_INSTALL_CMDS
	$(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D) install DESTDIR=$(HOST_DIR)
endef

define LZ4_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) liblz4
endef

define LZ4_INSTALL_STAGING_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) install DESTDIR=$(STAGING_DIR)
endef

define LZ4_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) install DESTDIR=$(TARGET_DIR)
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
