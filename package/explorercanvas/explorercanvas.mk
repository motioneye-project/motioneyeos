################################################################################
#
# explorercanvas
#
################################################################################

EXPLORERCANVAS_VERSION = r3
EXPLORERCANVAS_SITE = http://explorercanvas.googlecode.com/files/
EXPLORERCANVAS_SOURCE = excanvas_$(EXPLORERCANVAS_VERSION).zip
EXPLORERCANVAS_LICENSE = Apache-2.0
EXPLORERCANVAS_LICENSE_FILES = COPYING

define EXPLORERCANVAS_EXTRACT_CMDS
	unzip -d $(@D) $(DL_DIR)/$(EXPLORERCANVAS_SOURCE)
endef

define EXPLORERCANVAS_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/excanvas.compiled.js \
		$(TARGET_DIR)/var/www/excanvas.js
endef

$(eval $(generic-package))
