#############################################################
#
# freetype
#
#############################################################
FREETYPE_VERSION = $(strip $(subst ",, $(BR2_FREETYPE_VERSION)))
FREETYPE_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/freetype
FREETYPE_SOURCE = freetype-$(FREETYPE_VERSION).tar.bz2
FREETYPE_LIBTOOL_PATCH = NO
FREETYPE_INSTALL_STAGING = YES
FREETYPE_INSTALL_TARGET = NO
FREETYPE_MAKE_OPT = CCexe="$(HOSTCC)"
FREETYPE_DEPENDENCIES = uclibc pkgconfig zlib

$(eval $(call AUTOTARGETS,package,freetype))

$(FREETYPE_HOOK_POST_BUILD):
	-cp -a $(FREETYPE_DIR)/objs/.libs/libfreetype.so* $(TARGET_DIR)/usr/lib/
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libfreetype.so
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" $(FREETYPE_DIR)/builds/unix/freetype-config
	$(SED) "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" $(FREETYPE_DIR)/builds/unix/freetype-config
	touch $@

