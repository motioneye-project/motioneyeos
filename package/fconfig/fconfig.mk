################################################################################
#
# fconfig
#
################################################################################

FCONFIG_VERSION = 20080329
# Real upstream location has been disabled
# FCONFIG_SITE = http://andrzejekiert.ovh.org/software/fconfig
FCONFIG_SITE = http://sources.buildroot.net
FCONFIG_LICENSE = GPL-2.0+
FCONFIG_LICENSE_FILES = fconfig.c

define FCONFIG_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define FCONFIG_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/fconfig $(TARGET_DIR)/sbin/fconfig
endef

$(eval $(generic-package))
