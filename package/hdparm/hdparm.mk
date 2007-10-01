#############################################################
#
# hdparm
#
#############################################################
HDPARM_VERSION:=7.7
HDPARM_SOURCE:=hdparm-$(HDPARM_VERSION).tar.gz
HDPARM_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/hdparm
HDPARM_CAT:=$(ZCAT)
HDPARM_DIR:=$(BUILD_DIR)/hdparm-$(HDPARM_VERSION)
HDPARM_BINARY:=hdparm
HDPARM_TARGET_BINARY:=sbin/hdparm

$(DL_DIR)/$(HDPARM_SOURCE):
	 $(WGET) -P $(DL_DIR) $(HDPARM_SITE)/$(HDPARM_SOURCE)

hdparm-source: $(DL_DIR)/$(HDPARM_SOURCE)

$(HDPARM_DIR)/.unpacked: $(DL_DIR)/$(HDPARM_SOURCE)
	$(HDPARM_CAT) $(DL_DIR)/$(HDPARM_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(HDPARM_DIR) package/hdparm \*.patch
	touch $@

$(HDPARM_DIR)/$(HDPARM_BINARY): $(HDPARM_DIR)/.unpacked
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(HDPARM_DIR) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)"

$(TARGET_DIR)/$(HDPARM_TARGET_BINARY): $(HDPARM_DIR)/$(HDPARM_BINARY)
	rm -f $(TARGET_DIR)/$(HDPARM_TARGET_BINARY)
	$(INSTALL) -D -m 0755 $(HDPARM_DIR)/$(HDPARM_BINARY) $(TARGET_DIR)/$(HDPARM_TARGET_BINARY)
ifeq ($(BR2_HAVE_MANPAGES),y)
	$(INSTALL) -D $(HDPARM_DIR)/hdparm.8 $(TARGET_DIR)/usr/share/man/man8/hdparm.8
endif
	$(STRIPCMD) $(STRIP_STRIP_ALL) $@

hdparm: uclibc $(TARGET_DIR)/$(HDPARM_TARGET_BINARY)

hdparm-clean:
	-$(MAKE) -C $(HDPARM_DIR) clean
	rm -f $(TARGET_DIR)/$(HDPARM_TARGET_BINARY)

hdparm-dirclean:
	rm -rf $(HDPARM_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_HDPARM)),y)
TARGETS+=hdparm
endif
