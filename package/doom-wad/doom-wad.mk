################################################################################
#
# doom-wad
#
################################################################################

DOOM_WAD_VERSION = 1.9
DOOM_WAD_SOURCE = doom$(subst .,,$(DOOM_WAD_VERSION))s.zip
# Official server currently unavailable
# DOOM_WAD_SITE = ftp://ftp.idsoftware.com/idstuff/doom
DOOM_WAD_SITE = http://www.jbserver.com/downloads/games/doom/misc/shareware

define DOOM_WAD_EXTRACT_CMDS
	$(UNZIP) -p $(DL_DIR)/$($(PKG)_SOURCE) 'DOOMS_19.[12]' > \
		$(@D)/doom-$(DOOM_WAD_VERSION).zip
	$(UNZIP) -d $(@D) $(@D)/doom-$(DOOM_WAD_VERSION).zip DOOM1.WAD
endef

define DOOM_WAD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/DOOM1.WAD \
		$(TARGET_DIR)/usr/share/games/doom/doom1.wad
endef

$(eval $(generic-package))
