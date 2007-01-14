#############################################################
#
# psmisc
#
#############################################################
PSMISC_VER:=22.2
PSMISC_SOURCE:=psmisc-$(PSMISC_VER).tar.gz
PSMISC_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/psmisc
PSMISC_DIR:=$(BUILD_DIR)/psmisc-$(PSMISC_VER)
PSMISC_BINARY:=src/killall
PSMISC_TARGET_BINARY:=bin/killall

$(DL_DIR)/$(PSMISC_SOURCE):
	$(WGET) -P $(DL_DIR) $(PSMISC_SITE)/$(PSMISC_SOURCE)

$(PSMISC_DIR)/.unpacked: $(DL_DIR)/$(PSMISC_SOURCE)
	$(ZCAT) $(DL_DIR)/$(PSMISC_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(PSMISC_DIR)/.unpacked

$(PSMISC_DIR)/.configured: $(PSMISC_DIR)/.unpacked
	(cd $(PSMISC_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
		$(DISABLE_NLS) \
	);
	touch $(PSMISC_DIR)/.configured

$(PSMISC_DIR)/$(PSMISC_BINARY): $(PSMISC_DIR)/.configured
	$(MAKE) -C $(PSMISC_DIR)

$(TARGET_DIR)/$(PSMISC_TARGET_BINARY): $(PSMISC_DIR)/$(PSMISC_BINARY)
	$(MAKE) -C $(PSMISC_DIR) install DESTDIR=$(TARGET_DIR)
	rm -Rf $(TARGET_DIR)/usr/share/man

psmisc: uclibc ncurses $(TARGET_DIR)/$(PSMISC_TARGET_BINARY)

psmisc-source: $(DL_DIR)/$(PSMISC_SOURCE)

psmisc-clean:
	for bin in fuser killall pstree oldfuser pstree.x11 ; do \
		rm -f $(TARGET_DIR)/bin/$${bin} ; \
	done

psmisc-dirclean:
	rm -rf $(PSMISC_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_PSMISC)),y)
TARGETS+=psmisc
endif
