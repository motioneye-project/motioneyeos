#############################################################
#
# libpng (Portable Network Graphic library)
#
#############################################################
LIBPNG_VERSION:=1.2.32
LIBPNG_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libpng
LIBPNG_SOURCE = libpng-$(LIBPNG_VERSION).tar.bz2
LIBPNG_LIBTOOL_PATCH = NO
LIBPNG_INSTALL_STAGING = YES
LIBPNG_INSTALL_TARGET = YES
LIBPNG_CONF_ENV = \
		ac_cv_have_decl_malloc=yes \
		gl_cv_func_malloc_0_nonnull=yes \
		ac_cv_func_malloc_0_nonnull=yes \
		ac_cv_func_calloc_0_nonnull=yes \
		ac_cv_func_realloc_0_nonnull=yes
LIBPNG_CONF_OPT = \
		--without-libpng-compat \
		--without-x
LIBPNG_DEPENDENCIES = uclibc pkgconfig zlib

$(eval $(call AUTOTARGETS,package,libpng))

$(LIBPNG_HOOK_POST_INSTALL):
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^includedir=.*,includedir=\'$(STAGING_DIR)/usr/include/libpng12\',g" \
		-e "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" \
		$(STAGING_DIR)/usr/bin/libpng12-config
	touch $@

