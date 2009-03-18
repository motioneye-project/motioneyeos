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
FONTCONFIG_HOST_BINARY:=$(HOST_DIR)/usr/bin/fc-cache

$(FONTCONFIG_HOST_DIR)/.unpacked: $(DL_DIR)/$(FONTCONFIG_SOURCE)
	mkdir -p $(@D)
	$(INFLATE$(suffix $(FONTCONFIG_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(@D) $(TAR_OPTIONS) -
	touch $@

$(FONTCONFIG_HOST_DIR)/.configured: $(FONTCONFIG_HOST_DIR)/.unpacked $(FREETYPE_HOST_BINARY) $(EXPAT_HOST_BINARY)
	(cd $(@D); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		$(@D)/configure \
		--prefix=$(HOST_DIR)/usr \
		--sysconfdir=$(HOST_DIR)/etc \
		--disable-docs \
		--disable-static \
	)
	touch $@

$(FONTCONFIG_HOST_DIR)/.compiled: $(FONTCONFIG_HOST_DIR)/.configured
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
	touch $@

$(FONTCONFIG_HOST_BINARY): $(FONTCONFIG_HOST_DIR)/.compiled
	$(HOST_MAKE_ENV) $(MAKE) -C $(<D) install

host-fontconfig: $(FONTCONFIG_HOST_BINARY)

host-fontconfig-source: fontconfig-source

host-fontconfig-clean:
	rm -f $(addprefix $(FONTCONFIG_HOST_DIR)/,.unpacked .configured .compiled)
	-$(MAKE) -C $(FONTCONFIG_HOST_DIR) uninstall
	-$(MAKE) -C $(FONTCONFIG_HOST_DIR) clean

host-fontconfig-dirclean:
	rm -rf $(FONTCONFIG_HOST_DIR)
