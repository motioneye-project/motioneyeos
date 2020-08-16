################################################################################
#
# comix-cursors
#
################################################################################

COMIX_CURSORS_VERSION = 0.9.1
COMIX_CURSORS_SITE = https://limitland.gitlab.io/comixcursors
COMIX_CURSORS_SOURCE = ComixCursors-$(COMIX_CURSORS_VERSION).tar.bz2
COMIX_CURSORS_LICENSE = GPL-3.0
COMIX_CURSORS_STRIP_COMPONENTS = 0

define COMIX_CURSORS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/cursors/xorg-x11
	cp -a $(@D)/* \
		$(TARGET_DIR)/usr/share/cursors/xorg-x11
endef

$(eval $(generic-package))
