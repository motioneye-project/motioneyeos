################################################################################
#
# inadyn
#
################################################################################

INADYN_VERSION = 1.99.6
INADYN_SITE = $(call github,troglobit,inadyn,$(INADYN_VERSION))
INADYN_LICENSE = GPLv2+
INADYN_LICENSE_FILES = COPYING LICENSE

define INADYN_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define INADYN_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/inadyn $(TARGET_DIR)/usr/sbin/inadyn
	$(INSTALL) -D -m 0600 package/inadyn/inadyn.conf \
		$(TARGET_DIR)/etc/inadyn.conf
	$(INSTALL) -D -m 0755 package/inadyn/S70inadyn \
		$(TARGET_DIR)/etc/init.d/S70inadyn
endef

$(eval $(generic-package))
