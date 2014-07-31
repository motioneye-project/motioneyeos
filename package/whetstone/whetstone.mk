################################################################################
#
# whetstone
#
################################################################################

WHETSTONE_VERSION = 1.2
WHETSTONE_SOURCE = whetstone.c
WHETSTONE_SITE = http://www.netlib.org/benchmark

define WHETSTONE_EXTRACT_CMDS
	cp $(DL_DIR)/$($(PKG)_SOURCE) $(@D)/
endef

define WHETSTONE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) LDLIBS="-lm" -C $(@D) whetstone
endef

define WHETSTONE_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/whetstone $(TARGET_DIR)/usr/bin/whetstone
endef

$(eval $(generic-package))
