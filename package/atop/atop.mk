################################################################################
#
# atop
#
################################################################################

ATOP_VERSION = 2.4.0
ATOP_SITE = http://www.atoptool.nl/download
ATOP_LICENSE = GPL-2.0+
ATOP_LICENSE_FILES = COPYING
ATOP_DEPENDENCIES = ncurses zlib

define ATOP_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define ATOP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/atop $(TARGET_DIR)/usr/bin/atop
endef

$(eval $(generic-package))
