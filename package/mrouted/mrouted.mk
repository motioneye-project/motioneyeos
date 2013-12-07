################################################################################
#
# mrouted
#
################################################################################

MROUTED_VERSION = 3.9.6
MROUTED_SOURCE = mrouted-$(MROUTED_VERSION).tar.bz2
MROUTED_SITE = http://cloud.github.com/downloads/troglobit/mrouted
MROUTED_DEPENDENCIES = host-bison

define MROUTED_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define MROUTED_INSTALL_TARGET_CMDS
	$(MAKE) prefix=/usr DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
