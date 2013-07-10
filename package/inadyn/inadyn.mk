################################################################################
#
# inadyn
#
################################################################################

INADYN_VERSION = 1.98.1
INADYN_SOURCE = inadyn-$(INADYN_VERSION).tar.bz2
INADYN_SITE = https://github.com/downloads/troglobit/inadyn
INADYN_LICENSE = GPLv2+
INADYN_LICENSE_FILES = COPYING LICENSE

define INADYN_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define INADYN_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/inadyn $(TARGET_DIR)/usr/sbin/inadyn
	$(INSTALL) -D -m 0644 package/inadyn/inadyn.conf \
		$(TARGET_DIR)/etc/inadyn.conf
	$(INSTALL) -D -m 0755 package/inadyn/S70inadyn \
		$(TARGET_DIR)/etc/init.d/S70inadyn
endef

$(eval $(generic-package))
