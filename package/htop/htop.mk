################################################################################
#
# htop
#
################################################################################

HTOP_VERSION = 2.0.1
HTOP_SITE = http://hisham.hm/htop/releases/$(HTOP_VERSION)
HTOP_DEPENDENCIES = ncurses
# For 0001-Allow-to-override-ncurses-config-path.patch
HTOP_AUTORECONF = YES
HTOP_CONF_OPTS = --disable-unicode
# Prevent htop build system from searching the host paths
HTOP_CONF_ENV = htop_ncurses_config_script=$(STAGING_DIR)/usr/bin/ncurses5-config
HTOP_LICENSE = GPLv2
HTOP_LICENSE_FILES = COPYING

$(eval $(autotools-package))
