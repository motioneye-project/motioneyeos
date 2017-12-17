################################################################################
#
# obsidian-cursors
#
################################################################################

OBSIDIAN_CURSORS_VERSION = 1.0
OBSIDIAN_CURSORS_SITE = http://kde-look.org/CONTENT/content-files
OBSIDIAN_CURSORS_SOURCE = 73135-Obsidian.tar.bz2
OBSIDIAN_CURSORS_LICENSE = GPL

define OBSIDIAN_CURSORS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/cursors/xorg-x11/Obsidian
	cp -a $(@D)/cursors \
		$(TARGET_DIR)/usr/share/cursors/xorg-x11/Obsidian
endef

$(eval $(generic-package))
