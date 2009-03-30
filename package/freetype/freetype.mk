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
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libfreetype.so
ifneq ($(BR2_HAVE_DEVFILES),y)
	rm -f $(TARGET_DIR)/usr/bin/freetype-config
endif
	touch $@

# freetype for the host
FREETYPE_HOST_DIR:=$(BUILD_DIR)/freetype-$(FREETYPE_VERSION)-host

$(DL_DIR)/$(FREETYPE_SOURCE):
	$(call DOWNLOAD,$(FREETYPE_SITE),$(FREETYPE_SOURCE))

$(STAMP_DIR)/host_freetype_unpacked: $(DL_DIR)/$(FREETYPE_SOURCE)
	mkdir -p $(FREETYPE_HOST_DIR)
	$(INFLATE$(suffix $(FREETYPE_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(FREETYPE_HOST_DIR) $(TAR_OPTIONS) -
	touch $@

$(STAMP_DIR)/host_freetype_configured: $(STAMP_DIR)/host_freetype_unpacked $(STAMP_DIR)/host_pkgconfig_installed
	(cd $(FREETYPE_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
	)
	touch $@

$(STAMP_DIR)/host_freetype_compiled: $(STAMP_DIR)/host_freetype_configured
	$(MAKE) -C $(FREETYPE_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_freetype_installed: $(STAMP_DIR)/host_freetype_compiled
	$(HOST_MAKE_ENV) $(MAKE) -C $(FREETYPE_HOST_DIR) install
	touch $@

host-freetype: $(STAMP_DIR)/host_freetype_installed

host-freetype-source: freetype-source

host-freetype-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_freetype_,unpacked configured compiled installed)
	-$(MAKE) -C $(FREETYPE_HOST_DIR) uninstall
	-$(MAKE) -C $(FREETYPE_HOST_DIR) clean

host-freetype-dirclean:
	rm -rf $(FREETYPE_HOST_DIR)
