################################################################################
#
# mrouted
#
################################################################################

MROUTED_VERSION = 3.9.7
MROUTED_SITE = $(call github,troglobit,mrouted,$(MROUTED_VERSION))
MROUTED_DEPENDENCIES = host-bison
MROUTED_LICENSE = BSD-3c
MROUTED_LICENSE_FILES = LICENSE

define MROUTED_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) $(@D)/configure --enable-rsrr \
	)
endef

define MROUTED_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define MROUTED_INSTALL_TARGET_CMDS
	$(MAKE) prefix=/usr DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
