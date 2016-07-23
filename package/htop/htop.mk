################################################################################
#
# htop
#
################################################################################

HTOP_VERSION = 2.0.2
HTOP_SITE = http://hisham.hm/htop/releases/$(HTOP_VERSION)
HTOP_DEPENDENCIES = ncurses
HTOP_CONF_OPTS = --disable-unicode
# Prevent htop build system from searching the host paths
HTOP_CONF_ENV = HTOP_NCURSES_CONFIG_SCRIPT=$(STAGING_DIR)/usr/bin/ncurses5-config
HTOP_LICENSE = GPLv2
HTOP_LICENSE_FILES = COPYING

$(eval $(autotools-package))
