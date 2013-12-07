################################################################################
#
# sredird
#
################################################################################

SREDIRD_VERSION = 2.2.1-1.1
SREDIRD_SOURCE = sredird_$(SREDIRD_VERSION).tar.gz
SREDIRD_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/s/sredird

define SREDIRD_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define SREDIRD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/sredird $(TARGET_DIR)/usr/sbin/sredird
endef

$(eval $(generic-package))
