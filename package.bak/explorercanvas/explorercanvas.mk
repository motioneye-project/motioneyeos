################################################################################
#
# explorercanvas
#
################################################################################

EXPLORERCANVAS_VERSION = aa989ea9d9bac748638f7c66b0fc88e619715da6
EXPLORERCANVAS_SITE = $(call github,arv,ExplorerCanvas,$(EXPLORERCANVAS_VERSION))
EXPLORERCANVAS_LICENSE = Apache-2.0
EXPLORERCANVAS_LICENSE_FILES = COPYING

define EXPLORERCANVAS_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/excanvas.js $(TARGET_DIR)/var/www/excanvas.js
endef

$(eval $(generic-package))
