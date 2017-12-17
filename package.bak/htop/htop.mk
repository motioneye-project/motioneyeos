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

# ARC uses an old uClibc that needs dladdr() for backtrace support,
# which doesn't work for static only scenario, so as a workaround, we
# pretend that execinfo.h is not available.
ifeq ($(BR2_arc)$(BR2_STATIC_LIBS),yy)
HTOP_CONF_ENV += ac_cv_header_execinfo_h=no
endif

$(eval $(autotools-package))
