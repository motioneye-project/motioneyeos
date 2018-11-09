################################################################################
#
# lz4
#
################################################################################

LZ4_VERSION = v1.7.5
LZ4_SITE = $(call github,lz4,lz4,$(LZ4_VERSION))
LZ4_INSTALL_STAGING = YES
LZ4_LICENSE = BSD-2-Clause (library), GPL-2.0+ (programs)
LZ4_LICENSE_FILES = lib/LICENSE programs/COPYING

ifeq ($(BR2_STATIC_LIBS),y)
define LZ4_DISABLE_SHARED
	$(SED) '/SHARED/d' $(@D)/lib/Makefile
endef
LZ4_POST_PATCH_HOOKS += LZ4_DISABLE_SHARED
endif

define HOST_LZ4_BUILD_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) all
endef

define HOST_LZ4_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) PREFIX=$(HOST_DIR) \
		install -C $(@D)
endef

define LZ4_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) all
endef

define LZ4_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) DESTDIR=$(STAGING_DIR) \
		PREFIX=/usr install -C $(@D)
endef

define LZ4_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) DESTDIR=$(TARGET_DIR) \
		PREFIX=/usr install -C $(@D)
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
