################################################################################
#
# statserial
#
################################################################################

STATSERIAL_VERSION = 1.1
STATSERIAL_SITE = http://www.ibiblio.org/pub/Linux/system/serial
STATSERIAL_DEPENDENCIES = ncurses
STATSERIAL_LICENSE = GPL-2.0+
STATSERIAL_LICENSE_FILES = COPYING

define STATSERIAL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" -C $(@D)
endef

define STATSERIAL_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/statserial $(TARGET_DIR)/usr/bin/statserial
endef

$(eval $(generic-package))
