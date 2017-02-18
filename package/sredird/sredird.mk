################################################################################
#
# sredird
#
################################################################################

SREDIRD_VERSION = 2.2.2
SREDIRD_SITE = http://www.ibiblio.org/pub/Linux/system/serial
SREDIRD_LICENSE = GPLv2+
SREDIRD_LICENSE_FILES = COPYING

define SREDIRD_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define SREDIRD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/sredird $(TARGET_DIR)/usr/sbin/sredird
endef

$(eval $(generic-package))
