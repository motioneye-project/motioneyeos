#############################################################
#
# libpng (Portable Network Graphic library)
#
#############################################################
LIBPNG_VERSION:=1.2.38
LIBPNG_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libpng
LIBPNG_SOURCE = libpng-$(LIBPNG_VERSION).tar.bz2
LIBPNG_LIBTOOL_PATCH = NO
LIBPNG_INSTALL_STAGING = YES
LIBPNG_CONF_OPT = --without-libpng-compat
LIBPNG_DEPENDENCIES = host-pkg-config zlib

HOST_LIBPNG_LIBTOOL_PATCH = NO
HOST_LIBPNG_CONF_OPT = --without-libpng-compat
HOST_LIBPNG_DEPENDENCIES = host-pkg-config host-zlib

$(eval $(call AUTOTARGETS,package,libpng))
$(eval $(call AUTOTARGETS,package,libpng,host))

$(LIBPNG_HOOK_POST_INSTALL):
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^includedir=.*,includedir=\'$(STAGING_DIR)/usr/include/libpng12\',g" \
		-e "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" \
		$(STAGING_DIR)/usr/bin/libpng12-config
	touch $@

