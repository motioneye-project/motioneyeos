#############################################################
#
# fontconfig
#
#############################################################
FONTCONFIG_VERSION = 2.6.0
FONTCONFIG_SOURCE = fontconfig-$(FONTCONFIG_VERSION).tar.gz
FONTCONFIG_SITE = http://fontconfig.org/release
FONTCONFIG_AUTORECONF = YES
FONTCONFIG_USE_CONFIG_CACHE = NO
FONTCONFIG_INSTALL_STAGING = YES
FONTCONFIG_INSTALL_TARGET = YES
# This package does not like using the target cflags for some reason.
FONTCONFIG_CONF_ENV = CFLAGS="-I$(STAGING_DIR)/usr/include/freetype2"

FONTCONFIG_CONF_OPT = --with-arch=$(GNU_TARGET_NAME) \
		--with-freetype-config="$(STAGING_DIR)/usr/bin/freetype-config" \
		--with-cache-dir=/var/cache/fontconfig \
		--with-expat="$(STAGING_DIR)/usr/lib" \
		--with-expat-lib=$(STAGING_DIR)/usr/lib \
		--with-expat-includes=$(STAGING_DIR)/usr/include \
		--disable-docs

FONTCONFIG_DEPENDENCIES = uclibc freetype expat

$(eval $(call AUTOTARGETS,package,fontconfig))

# fontconfig for the host
FONTCONFIG_HOST_DIR:=$(BUILD_DIR)/fontconfig-$(FONTCONFIG_VERSION)-host

$(DL_DIR)/$(FONTCONFIG_SOURCE):
	$(call DOWNLOAD,$(FONTCONFIG_SITE),$(FONTCONFIG_SOURCE))

$(STAMP_DIR)/host_fontconfig_unpacked: $(DL_DIR)/$(FONTCONFIG_SOURCE)
	mkdir -p $(FONTCONFIG_HOST_DIR)
	$(INFLATE$(suffix $(FONTCONFIG_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(FONTCONFIG_HOST_DIR) $(TAR_OPTIONS) -
	touch $@

$(STAMP_DIR)/host_fontconfig_configured: $(STAMP_DIR)/host_fontconfig_unpacked $(STAMP_DIR)/host_freetype_installed $(STAMP_DIR)/host_expat_installed
	(cd $(FONTCONFIG_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
		--disable-docs \
		--disable-static \
	)
	touch $@

$(STAMP_DIR)/host_fontconfig_compiled: $(STAMP_DIR)/host_fontconfig_configured
	$(HOST_MAKE_ENV) $(MAKE) -C $(FONTCONFIG_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_fontconfig_installed: $(STAMP_DIR)/host_fontconfig_compiled
	$(HOST_MAKE_ENV) $(MAKE) -C $(FONTCONFIG_HOST_DIR) install
	touch $@

host-fontconfig: $(STAMP_DIR)/host_fontconfig_installed

host-fontconfig-source: fontconfig-source

host-fontconfig-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_fontconfig_,unpacked configured compiled installed)
	-$(MAKE) -C $(FONTCONFIG_HOST_DIR) uninstall
	-$(MAKE) -C $(FONTCONFIG_HOST_DIR) clean

host-fontconfig-dirclean:
	rm -rf $(FONTCONFIG_HOST_DIR)
