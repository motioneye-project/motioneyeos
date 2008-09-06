#############################################################
#
# madplay
#
#############################################################
MADPLAY_VERSION:=0.15.2b
MADPLAY_SOURCE:=madplay-$(MADPLAY_VERSION).tar.gz
MADPLAY_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/mad
MADPLAY_CAT:=$(ZCAT)
MADPLAY_DIR:=$(BUILD_DIR)/madplay-$(MADPLAY_VERSION)
MADPLAY_BIN:=madplay
MADPLAY_TARGET_BIN:=usr/bin/$(MADPLAY_BIN)

# Check if ALSA is built, then we should configure after alsa-lib so
# ./configure can find alsa-lib.
ifeq ($(strip $(BR2_PACKAGE_MADPLAY_ALSA)),y)
MADPLAY_USE_ALSA:=--with-alsa
MADPLAY_ALSA_DEP:=alsa-lib
endif

$(DL_DIR)/$(MADPLAY_SOURCE):
	 $(WGET) -P $(DL_DIR) $(MADPLAY_SITE)/$(MADPLAY_SOURCE)

$(MADPLAY_DIR)/.unpacked: $(DL_DIR)/$(MADPLAY_SOURCE)
	$(MADPLAY_CAT) $(DL_DIR)/$(MADPLAY_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MADPLAY_DIR) package/audio/madplay madplay\*.patch\*
	$(CONFIG_UPDATE) $(MADPLAY_DIR)
	touch $@

$(MADPLAY_DIR)/.configured: $(MADPLAY_DIR)/.unpacked
	(cd $(MADPLAY_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) $(BR2_MADPLAY_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		./configure \
		--target=$(REAL_GNU_TARGET_NAME) \
		--host=$(REAL_GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		$(MADPLAY_USE_ALSA) \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
	)
	touch $@

$(MADPLAY_DIR)/$(MADPLAY_BIN): $(MADPLAY_DIR)/.configured
	$(MAKE) -C $(MADPLAY_DIR)

$(TARGET_DIR)/$(MADPLAY_TARGET_BIN): $(MADPLAY_DIR)/$(MADPLAY_BIN)
	$(INSTALL) -D $(MADPLAY_DIR)/$(MADPLAY_BIN) $(TARGET_DIR)/$(MADPLAY_TARGET_BIN)
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/$(MADPLAY_TARGET_BIN)

madplay: uclibc $(MADPLAY_ALSA_DEP) libmad libid3tag $(TARGET_DIR)/$(MADPLAY_TARGET_BIN)

madplay-clean:
	rm -f $(TARGET_DIR)/$(MADPLAY_TARGET_BIN)
	-$(MAKE) -C $(MADPLAY_DIR) clean

madplay-dirclean:
	rm -rf $(MADPLAY_DIR)

madplay-source: $(DL_DIR)/$(MADPLAY_SOURCE)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_MADPLAY)),y)
TARGETS+=madplay
endif
