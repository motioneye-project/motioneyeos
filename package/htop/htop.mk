################################################################################
#
# htop
#
################################################################################

HTOP_VERSION = 2.0.2
HTOP_SITE = http://hisham.hm/htop/releases/$(HTOP_VERSION)
HTOP_DEPENDENCIES = ncurses
# Prevent htop build system from searching the host paths
HTOP_CONF_ENV = HTOP_NCURSES_CONFIG_SCRIPT=$(STAGING_DIR)/usr/bin/ncurses5-config
HTOP_LICENSE = GPLv2
HTOP_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
HTOP_CONF_OPTS += --enable-unicode
else
HTOP_CONF_OPTS += --disable-unicode
endif

$(eval $(autotools-package))
