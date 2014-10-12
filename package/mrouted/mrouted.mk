################################################################################
#
# mrouted
#
################################################################################

MROUTED_VERSION = 3.9.6
MROUTED_SITE = $(call github,troglobit,mrouted,$(MROUTED_VERSION))
MROUTED_DEPENDENCIES = host-bison

define MROUTED_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define MROUTED_INSTALL_TARGET_CMDS
	$(MAKE) prefix=/usr DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
