#############################################################
#
# lzo
#
#############################################################
LZO_VERSION:=2.03
LZO_SOURCE:=lzo-$(LZO_VERSION).tar.gz
LZO_SITE:=http://www.oberhumer.com/opensource/lzo/download
LZO_AUTORECONF = NO
LZO_INSTALL_STAGING = YES
LZO_INSTALL_TARGET = YES
LZO_INSTALL_STAGING_OPT = CC="$(TARGET_CC)" DESTDIR=$(STAGING_DIR) install
LZO_CONF_ENV =
LZO_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package,lzo))

# lzo for the host
LZO_HOST_DIR:=$(BUILD_DIR)/lzo-$(LZO_VERSION)-host

$(DL_DIR)/$(LZO_SOURCE):
	$(call DOWNLOAD,$(LZO_SITE),$(LZO_SOURCE))

$(STAMP_DIR)/host_lzo_unpacked: $(DL_DIR)/$(LZO_SOURCE)
	mkdir -p $(LZO_HOST_DIR)
	$(INFLATE$(suffix $(LZO_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(LZO_HOST_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LZO_HOST_DIR) package/lzo/ \*.patch
	touch $@

$(STAMP_DIR)/host_lzo_configured: $(STAMP_DIR)/host_lzo_unpacked
	(cd $(LZO_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
	)
	touch $@

$(STAMP_DIR)/host_lzo_compiled: $(STAMP_DIR)/host_lzo_configured
	$(MAKE) -C $(LZO_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_lzo_installed: $(STAMP_DIR)/host_lzo_compiled
	$(MAKE) -C $(LZO_HOST_DIR) install
	touch $@

host-lzo: $(STAMP_DIR)/host_lzo_installed

host-lzo-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_lzo_,unpacked configured compiled installed)
	-$(MAKE) -C $(LZO_HOST_DIR) uninstall
	-$(MAKE) -C $(LZO_HOST_DIR) clean

host-lzo-dirclean:
	rm -rf $(LZO_HOST_DIR)
