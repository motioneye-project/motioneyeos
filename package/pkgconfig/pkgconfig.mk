#############################################################
#
# pkgconfig
#
#############################################################
PKGCONFIG_VERSION:=0.23
PKGCONFIG_SOURCE:=pkg-config-$(PKGCONFIG_VERSION).tar.gz
PKGCONFIG_SITE:=http://pkgconfig.freedesktop.org/releases/
PKGCONFIG_DIR:=$(BUILD_DIR)/pkg-config-$(PKGCONFIG_VERSION)
PKGCONFIG_CAT:=$(ZCAT)
PKGCONFIG_BINARY:=pkg-config
PKGCONFIG_HOST_BINARY:=$(HOST_DIR)/usr/bin/pkg-config

$(DL_DIR)/$(PKGCONFIG_SOURCE):
	 $(call DOWNLOAD,$(PKGCONFIG_SITE),$(PKGCONFIG_SOURCE))

pkgconfig-source: $(DL_DIR)/$(PKGCONFIG_SOURCE)

$(PKGCONFIG_DIR)/.unpacked: $(DL_DIR)/$(PKGCONFIG_SOURCE)
	$(PKGCONFIG_CAT) $(DL_DIR)/$(PKGCONFIG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(PKGCONFIG_DIR) package/pkgconfig/ \*.patch
	touch $@

$(PKGCONFIG_DIR)/.configured: $(PKGCONFIG_DIR)/.unpacked
	(cd $(PKGCONFIG_DIR); rm -rf config.cache; \
		./configure \
		--prefix=$(HOST_DIR)/usr \
		--sysconfdir=$(HOST_DIR)/etc \
		--with-pc-path="$(STAGING_DIR)/usr/lib/pkgconfig" \
		--disable-static \
	)
	touch $@

$(PKGCONFIG_DIR)/$(PKGCONFIG_BINARY): $(PKGCONFIG_DIR)/.configured
	$(MAKE) -C $(PKGCONFIG_DIR)

$(PKGCONFIG_HOST_BINARY): $(PKGCONFIG_DIR)/$(PKGCONFIG_BINARY)
	$(MAKE) -C $(PKGCONFIG_DIR) install

host-pkgconfig pkgconfig: $(PKGCONFIG_HOST_BINARY)

host-pkgconfig-clean pkgconfig-clean:
	rm -f $(addprefix $(PKGCONFIG_DIR)/,.unpacked .configured .compiled)
	-$(MAKE) -C $(PKGCONFIG_DIR) uninstall
	-$(MAKE) -C $(PKGCONFIG_DIR) clean

host-pkgconfig-dirclean pkgconfig-dirclean:
	rm -rf $(PKGCONFIG_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_PKGCONFIG),y)
TARGETS+=pkgconfig
endif
