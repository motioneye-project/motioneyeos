################################################################################
#
# libcofi
#
################################################################################

LIBCOFI_VERSION = 7313fbe12b0593034d0a1b606bf33c7cf4ababce
LIBCOFI_SITE = $(call github,simonjhall,copies-and-fills,$(LIBCOFI_VERSION))
LIBCOFI_LICENSE = LGPLv2.1
LIBCOFI_LICENSE_FILES = README.md

define LIBCOFI_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define LIBCOFI_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libcofi_rpi.so $(TARGET_DIR)/usr/lib/libcofi_rpi.so
endef

$(eval $(generic-package))
