#############################################################
#
# pkgconfig
#
#############################################################
PKGCONFIG_VERSION:=0.23
PKGCONFIG_SOURCE:=pkg-config-$(PKGCONFIG_VERSION).tar.gz
PKGCONFIG_SITE:=http://pkgconfig.freedesktop.org/releases/

# pkgconfig for the host
PKGCONFIG_HOST_DIR:=$(BUILD_DIR)/pkg-config-$(PKGCONFIG_VERSION)-host
PKGCONFIG_HOST_BINARY:=$(HOST_DIR)/usr/bin/pkg-config

$(DL_DIR)/$(PKGCONFIG_SOURCE):
	 $(call DOWNLOAD,$(PKGCONFIG_SITE),$(PKGCONFIG_SOURCE))

pkgconfig-source: $(DL_DIR)/$(PKGCONFIG_SOURCE)

$(PKGCONFIG_HOST_DIR)/.unpacked: $(DL_DIR)/$(PKGCONFIG_SOURCE)
	mkdir -p $(@D)
	$(INFLATE$(suffix $(PKGCONFIG_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(@D) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(@D) package/pkgconfig/ \*.patch
	touch $@

$(PKGCONFIG_HOST_DIR)/.configured: $(PKGCONFIG_HOST_DIR)/.unpacked
	(cd $(@D); rm -rf config.cache; \
		./configure \
		--prefix=$(HOST_DIR)/usr \
		--sysconfdir=$(HOST_DIR)/etc \
		--with-pc-path="$(STAGING_DIR)/usr/lib/pkgconfig" \
		--disable-static \
	)
	touch $@

$(PKGCONFIG_HOST_DIR)/.compiled: $(PKGCONFIG_HOST_DIR)/.configured
	$(MAKE) -C $(@D)

$(PKGCONFIG_HOST_BINARY): $(PKGCONFIG_HOST_DIR)/.compiled
	$(MAKE) -C $(<D) install

host-pkgconfig pkgconfig: $(PKGCONFIG_HOST_BINARY)

host-pkgconfig-clean pkgconfig-clean:
	rm -f $(addprefix $(PKGCONFIG_HOST_DIR)/,.unpacked .configured .compiled)
	-$(MAKE) -C $(PKGCONFIG_HOST_DIR) uninstall
	-$(MAKE) -C $(PKGCONFIG_HOST_DIR) clean

host-pkgconfig-dirclean pkgconfig-dirclean:
	rm -rf $(PKGCONFIG_HOST_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_PKGCONFIG),y)
TARGETS+=pkgconfig
endif
