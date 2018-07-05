################################################################################
#
# pigz
#
################################################################################

PIGZ_VERSION = v2.4
PIGZ_SITE = $(call github,madler,pigz,$(PIGZ_VERSION))
PIGZ_DEPENDENCIES = zlib
PIGZ_LICENSE = Zlib
PIGZ_LICENSE_FILES = README

define PIGZ_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define PIGZ_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/pigz $(TARGET_DIR)/usr/bin/pigz
endef

$(eval $(generic-package))
