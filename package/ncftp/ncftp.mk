################################################################################
#
# ncftp
#
################################################################################

NCFTP_VERSION = 3.2.5
NCFTP_SOURCE = ncftp-$(NCFTP_VERSION)-src.tar.bz2
NCFTP_SITE = ftp://ftp.ncftp.com/ncftp
NCFTP_TARGET_BINS = ncftp

ifeq ($(BR2_PACKAGE_NCFTP_GET),y)
	NCFTP_TARGET_BINS += ncftpget
endif

ifeq ($(BR2_PACKAGE_NCFTP_PUT),y)
	NCFTP_TARGET_BINS += ncftpput
endif

ifeq ($(BR2_PACKAGE_NCFTP_LS),y)
	NCFTP_TARGET_BINS += ncftpls
endif

ifeq ($(BR2_PACKAGE_NCFTP_BATCH),y)
	NCFTP_TARGET_BINS += ncftpbatch
	NCFTP_INSTALL_NCFTP_BATCH = \
		ln -s /usr/bin/ncftpbatch $(TARGET_DIR)/usr/bin/ncftpspooler
endif

ifeq ($(BR2_PACKAGE_NCFTP_BOOKMARKS),y)
	NCFTP_TARGET_BINS += ncftpbookmarks
	NCFTP_DEPENDENCIES += ncurses
endif

define NCFTP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(addprefix $(NCFTP_DIR)/bin/, $(NCFTP_TARGET_BINS)) $(TARGET_DIR)/usr/bin
	$(NCFTP_INSTALL_NCFTP_BATCH)
endef

define NCFTP_UNINSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, $(NCFTP_TARGET_BINS) ncftpspooler)
endef

$(eval $(autotools-package))
