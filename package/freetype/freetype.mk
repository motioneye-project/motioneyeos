#############################################################
#
# freetype
#
#############################################################
FREETYPE_VERSION = 2.3.9
FREETYPE_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/freetype
FREETYPE_SOURCE = freetype-$(FREETYPE_VERSION).tar.bz2
FREETYPE_LIBTOOL_PATCH = NO
HOST_FREETYPE_LIBTOOL_PATCH = NO
FREETYPE_INSTALL_STAGING = YES
FREETYPE_INSTALL_TARGET = YES
FREETYPE_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
FREETYPE_MAKE_OPT = CCexe="$(HOSTCC)"
FREETYPE_DEPENDENCIES = host-pkg-config $(if $(BR2_PACKAGE_ZLIB),zlib)

HOST_FREETYPE_DEPENDENCIES = host-pkg-config

$(eval $(call AUTOTARGETS,package,freetype))
$(eval $(call AUTOTARGETS,package,freetype,host))

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
