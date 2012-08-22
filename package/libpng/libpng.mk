#############################################################
#
# libpng (Portable Network Graphic library)
#
#############################################################

LIBPNG_VERSION = 1.4.12
LIBPNG_SERIES = 14
LIBPNG_SOURCE = libpng-$(LIBPNG_VERSION).tar.bz2
LIBPNG_SITE = http://downloads.sourceforge.net/project/libpng/libpng${LIBPNG_SERIES}/$(LIBPNG_VERSION)
LIBPNG_LICENSE = libpng license
LIBPNG_LICENSE_FILES = LICENSE
LIBPNG_INSTALL_STAGING = YES
LIBPNG_DEPENDENCIES = host-pkg-config zlib

define LIBPNG_STAGING_LIBPNG12_CONFIG_FIXUP
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^includedir=.*,includedir=\'$(STAGING_DIR)/usr/include/libpng$(LIBPNG_SERIES)\',g" \
		-e "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" \
		$(STAGING_DIR)/usr/bin/libpng$(LIBPNG_SERIES)-config
endef

LIBPNG_POST_INSTALL_STAGING_HOOKS += LIBPNG_STAGING_LIBPNG12_CONFIG_FIXUP

define LIBPNG_REMOVE_CONFIG_SCRIPTS
	$(RM) -f $(TARGET_DIR)/usr/bin/libpng$(LIBPNG_SERIES)-config \
		 $(TARGET_DIR)/usr/bin/libpng-config
endef

ifneq ($(BR2_HAVE_DEVFILES),y)
LIBPNG_POST_INSTALL_TARGET_HOOKS += LIBPNG_REMOVE_CONFIG_SCRIPTS
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
