#############################################################
#
# ncftp client
#
#############################################################
NCFTP_VERSION:=3.2.2
NCFTP_SOURCE:=ncftp-$(NCFTP_VERSION)-src.tar.bz2
NCFTP_SITE:=ftp://ftp.ncftp.com/ncftp

NCFTP_TARGET_BINS:=ncftp

ifeq ($(BR2_PACKAGE_NCFTP_GET),y)
NCFTP_TARGET_BINS+=ncftpget
endif

ifeq ($(BR2_PACKAGE_NCFTP_PUT),y)
NCFTP_TARGET_BINS+=ncftpput
endif

ifeq ($(BR2_PACKAGE_NCFTP_LS),y)
NCFTP_TARGET_BINS+=ncftpls
endif

ifeq ($(BR2_PACKAGE_NCFTP_BATCH),y)
NCFTP_TARGET_BINS+=ncftpbatch
endif

ifeq ($(BR2_PACKAGE_NCFTP_BOOKMARKS),y)
NCFTP_TARGET_BINS+=ncftpbookmarks
NCFTP_DEPENDENCIES:=ncurses
endif

$(eval $(call AUTOTARGETS,package,ncftp))

$(NCFTP_TARGET_INSTALL_TARGET):
	$(call MESSAGE,"Installing to target")
	$(INSTALL) -m 0755 $(addprefix $(NCFTP_DIR)/bin/, $(NCFTP_TARGET_BINS)) $(TARGET_DIR)/usr/bin
ifeq ($(BR2_PACKAGE_NCFTP_BATCH),y)
	ln -s /usr/bin/ncftpbatch $(TARGET_DIR)/usr/bin/ncftpspooler
endif
ifeq ($(BR2_ENABLE_DEBUG),)
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(addprefix $(TARGET_DIR)/usr/bin/, $(NCFTP_TARGET_BINS))
endif
	touch $@

$(NCFTP_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, $(NCFTP_TARGET_BINS) ncftpspooler)
	rm -f $(NCFTP_TARGET_INSTALL_TARGET)
