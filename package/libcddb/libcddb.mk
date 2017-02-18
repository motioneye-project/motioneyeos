################################################################################
#
# libcddb
#
################################################################################

LIBCDDB_VERSION = 1.3.2
LIBCDDB_SOURCE = libcddb-$(LIBCDDB_VERSION).tar.bz2
LIBCDDB_SITE = http://downloads.sourceforge.net/libcddb
LIBCDDB_LICENSE = LGPLv2+
LIBCDDB_LICENSE_FILES = COPYING
LIBCDDB_INSTALL_STAGING = YES

ifeq ($(BR2_ENABLE_LOCALE),)
LIBCDDB_DEPENDENCIES += libiconv
endif

define LIBCDDB_REMOVE_CDDB_QUERY
	rm -f $(TARGET_DIR)/usr/bin/cddb_query
endef

ifeq ($(BR2_PACKAGE_LIBCDDB_INSTALL_CDDB_QUERY),)
LIBCDDB_POST_INSTALL_TARGET_HOOKS += LIBCDDB_REMOVE_CDDB_QUERY
endif

$(eval $(autotools-package))
