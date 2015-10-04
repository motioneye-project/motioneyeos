################################################################################
#
# vnstat
#
################################################################################

VNSTAT_VERSION = 1.12
VNSTAT_SITE = http://humdi.net/vnstat
VNSTAT_LICENSE = GPLv2
VNSTAT_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_GD)$(BR2_PACKAGE_LIBPNG),yy)
VNSTAT_DEPENDENCIES = gd
VNSTAT_GD_MAKE_OPT = all
define VNSTAT_INSTALL_VNSTATI_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/vnstati $(TARGET_DIR)/usr/bin/vnstati
endef
endif

define VNSTAT_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(VNSTAT_GD_MAKE_OPT)
endef

define VNSTAT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/vnstat $(TARGET_DIR)/usr/bin/vnstat
	$(INSTALL) -D -m 0755 $(@D)/src/vnstatd $(TARGET_DIR)/usr/sbin/vnstatd
	$(VNSTAT_INSTALL_VNSTATI_CMDS)
endef

$(eval $(generic-package))
