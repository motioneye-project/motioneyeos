#############################################################
#
# hdparm
#
#############################################################

HDPARM_VERSION = 9.39
HDPARM_SITE = http://downloads.sourceforge.net/project/hdparm/hdparm

define HDPARM_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)"
endef

ifeq ($(BR2_HAVE_DOCUMENTATION),y)
define HDPARM_INSTALL_DOCUMENTATION
	$(INSTALL) -D $(@D)/hdparm.8 $(TARGET_DIR)/usr/share/man/man8/hdparm.8
endef
endif

define HDPARM_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/hdparm $(TARGET_DIR)/sbin/hdparm
	$(HDPARM_INSTALL_DOCUMENTATION)
endef

define HDPARM_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/sbin/hdparm
	rm -f $(TARGET_DIR)/usr/share/man/man8/hdparm.8
endef

define HDPARM_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
