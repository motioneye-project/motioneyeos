################################################################################
#
# ti-uim
#
################################################################################

TI_UIM_VERSION = a0236bc252e6484835ce266ae4a50b361f6a902d
TI_UIM_SITE = $(call github,96boards,uim,$(TI_UIM_VERSION))
TI_UIM_LICENSE = GPL-2.0+
TI_UIM_LICENSE_FILES = uim.h

define TI_UIM_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define TI_UIM_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/uim \
		$(TARGET_DIR)/usr/sbin/uim
endef

$(eval $(generic-package))
