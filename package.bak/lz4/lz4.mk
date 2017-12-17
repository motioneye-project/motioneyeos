################################################################################
#
# lz4
#
################################################################################

LZ4_VERSION = r131
LZ4_SITE = $(call github,Cyan4973,lz4,$(LZ4_VERSION))
LZ4_INSTALL_STAGING = YES
LZ4_LICENSE = BSD-2c (library), GPLv2+ (programs)
LZ4_LICENSE_FILES = lib/LICENSE programs/COPYING

ifeq ($(BR2_STATIC_LIBS),y)
define LZ4_DISABLE_SHARED
	$(SED) '/SHARED/d' $(@D)/lib/Makefile
endef
LZ4_POST_PATCH_HOOKS += LZ4_DISABLE_SHARED
endif

define HOST_LZ4_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D)
endef

define HOST_LZ4_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) PREFIX=$(HOST_DIR)/usr \
		install -C $(@D)
endef

define LZ4_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/lib
endef

define LZ4_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) DESTDIR=$(STAGING_DIR) \
		PREFIX=/usr install -C $(@D)
endef

define LZ4_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) \
		PREFIX=/usr install -C $(@D)/lib
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
