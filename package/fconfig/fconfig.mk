################################################################################
#
# fconfig
#
################################################################################

FCONFIG_VERSION = 20080329
FCONFIG_SITE = http://andrzejekiert.ovh.org/software/fconfig
FCONFIG_LICENSE = GPLv2+
FCONFIG_LICENSE_FILES = fconfig.c

define FCONFIG_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)"
endef

define FCONFIG_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/fconfig $(TARGET_DIR)/sbin/fconfig
endef

$(eval $(generic-package))
