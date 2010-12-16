#############################################################
#
# freetype
#
#############################################################
FREETYPE_VERSION = 2.4.4
FREETYPE_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/freetype
FREETYPE_SOURCE = freetype-$(FREETYPE_VERSION).tar.bz2
FREETYPE_INSTALL_STAGING = YES
FREETYPE_INSTALL_TARGET = YES
FREETYPE_MAKE_OPT = CCexe="$(HOSTCC)"
FREETYPE_DEPENDENCIES = host-pkg-config $(if $(BR2_PACKAGE_ZLIB),zlib)

HOST_FREETYPE_DEPENDENCIES = host-pkg-config

define FREETYPE_FREETYPE_CONFIG_STAGING_FIXUP
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^includedir=.*,includedir=\'$(STAGING_DIR)/usr/include/freetype2\',g" \
		-e "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" \
		$(STAGING_DIR)/usr/bin/freetype-config
endef

FREETYPE_POST_INSTALL_STAGING_HOOKS += FREETYPE_FREETYPE_CONFIG_STAGING_FIXUP

define FREETYPE_FREETYPE_CONFIG_TARGET_REMOVE
	rm -f $(TARGET_DIR)/usr/bin/freetype-config
endef

ifneq ($(BR2_HAVE_DEVFILES),y)
FREETYPE_POST_INSTALL_TARGET_HOOKS += FREETYPE_FREETYPE_CONFIG_TARGET_REMOVE
endif

$(eval $(call AUTOTARGETS,package,freetype))
$(eval $(call AUTOTARGETS,package,freetype,host))
