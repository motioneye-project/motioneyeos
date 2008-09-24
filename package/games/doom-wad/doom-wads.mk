#############################################################
#
# doom-wad
#
#############################################################

DOOM_WAD_VERSION = 1.8
DOOM_WAD_SOURCE = doom-$(DOOM_WAD_VERSION).wad.gz
DOOM_WAD_SITE = ftp://ftp.idsoftware.com/idstuff/doom/
DOOM_WAD_DIR=$(BUILD_DIR)/doom-wad-$(DOOM_WAD_VERSION)

$(DL_DIR)/$(DOOM_WAD_SOURCE):
	 $(WGET) -P $(DL_DIR) $(DOOM_WAD_SITE)/$(DOOM_WAD_SOURCE)

doom-wad-source: $(DL_DIR)/$(DOOM_WAD_SOURCE)

$(DOOM_WAD_DIR)/.unpacked: $(DL_DIR)/$(DOOM_WAD_SOURCE)
	$(INSTALL) -D $(DL_DIR)/$(DOOM_WAD_SOURCE) $(DOOM_WAD_DIR)/$(DOOM_WAD_SOURCE)
	$(ZCAT) $(DOOM_WAD_DIR)/$(DOOM_WAD_SOURCE) > \
		$(DOOM_WAD_DIR)/doom-$(DOOM_WAD_VERSION).wad
	touch $@

$(TARGET_DIR)/usr/share/games/doom/doom1.wad: $(DOOM_WAD_DIR)/.unpacked
	$(INSTALL) -D $(DOOM_WAD_DIR)/doom-$(DOOM_WAD_VERSION).wad $@

doom-wad: $(TARGET_DIR)/usr/share/games/doom/doom1.wad

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_DOOM_WAD)),y)
TARGETS+=doom-wad
endif
