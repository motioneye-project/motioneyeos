#############################################################
#
# madplay
#
#############################################################

MADPLAY_VERSION=0.15.2b
MADPLAY_SOURCE=madplay-$(MADPLAY_VERSION).tar.gz
MADPLAY_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/mad
MADPLAY_DIR=$(BUILD_DIR)/madplay-$(MADPLAY_VERSION)
MADPLAY_CAT:=$(ZCAT)

$(DL_DIR)/$(MADPLAY_SOURCE):
	$(WGET) -P $(DL_DIR) $(MADPLAY_SITE)/$(MADPLAY_SOURCE)

$(MADPLAY_DIR)/.unpacked: $(DL_DIR)/$(MADPLAY_SOURCE)
	$(MADPLAY_CAT) $(DL_DIR)/$(MADPLAY_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(MADPLAY_DIR)/.unpacked

$(MADPLAY_DIR)/.configured: $(MADPLAY_DIR)/.unpacked
	(cd $(MADPLAY_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		$(DISABLE_NLS) \
	);
	touch $(MADPLAY_DIR)/.configured

$(MADPLAY_DIR)/src/madplay: $(MADPLAY_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(MADPLAY_DIR)

$(MADPLAY_DIR)/.installed: $(MADPLAY_DIR)/src/madplay
	$(MAKE) -C $(MADPLAY_DIR) DESTDIR=$(TARGET_DIR) install
	touch $(MADPLAY_DIR)/.installed

madplay: uclibc libmad $(MADPLAY_DIR)/.installed

madplay-source: $(DL_DIR)/$(MADPLAY_SOURCE)

madplay-clean:
	@if [ -d $(MADPLAY_DIR)/Makefile ] ; then \
		$(MAKE) -C $(MADPLAY_DIR) clean ; \
	fi;

madplay-dirclean:
	rm -rf $(MADPLAY_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_MADPLAY)),y)
TARGETS+=madplay
endif
