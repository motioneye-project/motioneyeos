################################################################################
#
# fconfig
#
################################################################################

FCONFIG_VERSION = 20080329
FCONFIG_SOURCE = fconfig-$(FCONFIG_VERSION).tar.gz
FCONFIG_SITE = http://andrzejekiert.ovh.org/software/fconfig/

define FCONFIG_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)"
endef

define FCONFIG_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/fconfig $(TARGET_DIR)/sbin/fconfig
endef

define FCONFIG_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/sbin/fconfig
endef

define FCONFIG_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
