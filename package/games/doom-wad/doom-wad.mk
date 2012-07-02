#############################################################
#
# doom-wad
#
#############################################################

DOOM_WAD_VERSION = 1.8
DOOM_WAD_SOURCE = doom-$(DOOM_WAD_VERSION).wad.gz
DOOM_WAD_SITE = ftp://ftp.idsoftware.com/idstuff/doom/

define DOOM_WAD_EXTRACT_CMDS
	$(ZCAT) $(DL_DIR)/$($(PKG)_SOURCE) > $(@D)/doom1.wad
endef

define DOOM_WAD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/doom1.wad \
		$(TARGET_DIR)/usr/share/games/doom/doom1.wad
endef

define DOOM_WAD_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/share/games/doom/doom1.wad
endef

$(eval $(generic-package))
