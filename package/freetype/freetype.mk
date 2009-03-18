#############################################################
#
# freetype
#
#############################################################
FREETYPE_VERSION = 2.3.9
FREETYPE_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/freetype
FREETYPE_SOURCE = freetype-$(FREETYPE_VERSION).tar.bz2
FREETYPE_LIBTOOL_PATCH = NO
FREETYPE_INSTALL_STAGING = YES
FREETYPE_INSTALL_TARGET = YES
FREETYPE_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
FREETYPE_MAKE_OPT = CCexe="$(HOSTCC)"
FREETYPE_DEPENDENCIES = uclibc host-pkgconfig $(if $(BR2_PACKAGE_ZLIB),zlib)

$(eval $(call AUTOTARGETS,package,freetype))

$(FREETYPE_HOOK_POST_INSTALL):
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^includedir=.*,includedir=\'$(STAGING_DIR)/usr/include/freetype2\',g" \
		-e "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" \
		$(STAGING_DIR)/usr/bin/freetype-config
	touch $@

# freetype for the host
FREETYPE_HOST_DIR:=$(BUILD_DIR)/freetype-$(FREETYPE_VERSION)-host
FREETYPE_HOST_BINARY:=$(HOST_DIR)/usr/bin/freetype-config

$(FREETYPE_HOST_DIR)/.unpacked: $(DL_DIR)/$(FREETYPE_SOURCE)
	mkdir -p $(@D)
	$(INFLATE$(suffix $(FREETYPE_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(@D) $(TAR_OPTIONS) -
	touch $@

$(FREETYPE_HOST_DIR)/.configured: $(FREETYPE_HOST_DIR)/.unpacked $(PKGCONFIG_HOST_BINARY)
	(cd $(@D); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		$(@D)/configure \
		--prefix=$(HOST_DIR)/usr \
		--sysconfdir=$(HOST_DIR)/etc \
	)
	touch $@

$(FREETYPE_HOST_DIR)/.compiled: $(FREETYPE_HOST_DIR)/.configured
	$(MAKE) -C $(@D)
	touch $@

$(FREETYPE_HOST_BINARY): $(FREETYPE_HOST_DIR)/.compiled
	$(HOST_MAKE_ENV) $(MAKE) -C $(<D) install

host-freetype: $(FREETYPE_HOST_BINARY)

host-freetype-source: freetype-source

host-freetype-clean:
	rm -f $(addprefix $(FREETYPE_HOST_DIR)/,.unpacked .configured .compiled)
	-$(MAKE) -C $(FREETYPE_HOST_DIR) uninstall
	-$(MAKE) -C $(FREETYPE_HOST_DIR) clean

host-freetype-dirclean:
	rm -rf $(FREETYPE_HOST_DIR)
