################################################################################
#
# less
#
################################################################################

LESS_VERSION = 551
LESS_SITE = http://www.greenwoodsoftware.com/less
LESS_LICENSE = GPL-3.0+
LESS_LICENSE_FILES = COPYING
LESS_DEPENDENCIES = ncurses

define LESS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/less $(TARGET_DIR)/usr/bin/less
endef

$(eval $(autotools-package))
