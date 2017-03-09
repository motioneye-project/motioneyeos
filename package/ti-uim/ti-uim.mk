################################################################################
#
# ti-uim
#
################################################################################

TI_UIM_VERSION = c73894456df5def97111cb33d2106b684b8b7959
TI_UIM_SITE = $(call github,96boards,uim,$(TI_UIM_VERSION))
TI_UIM_LICENSE = GPLv2+

define TI_UIM_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define TI_UIM_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/uim \
		$(TARGET_DIR)/usr/sbin/uim
endef

$(eval $(generic-package))
