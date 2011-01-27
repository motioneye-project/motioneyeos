#############################################################
#
# libpng (Portable Network Graphic library)
#
#############################################################
LIBPNG_VERSION = 1.4.5
LIBPNG_SERIES = 14
LIBPNG_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libpng
LIBPNG_SOURCE = libpng-$(LIBPNG_VERSION).tar.bz2
LIBPNG_INSTALL_STAGING = YES
LIBPNG_DEPENDENCIES = host-pkg-config zlib

HOST_LIBPNG_DEPENDENCIES = host-pkg-config host-zlib

define LIBPNG_STAGING_LIBPNG12_CONFIG_FIXUP
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^includedir=.*,includedir=\'$(STAGING_DIR)/usr/include/libpng$(LIBPNG_SERIES)\',g" \
		-e "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" \
		$(STAGING_DIR)/usr/bin/libpng$(LIBPNG_SERIES)-config
endef

LIBPNG_POST_INSTALL_STAGING_HOOKS += LIBPNG_STAGING_LIBPNG12_CONFIG_FIXUP

$(eval $(call AUTOTARGETS,package,libpng))
$(eval $(call AUTOTARGETS,package,libpng,host))
