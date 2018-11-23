################################################################################
#
# libtorrent-rasterbar
#
################################################################################

LIBTORRENT_RASTERBAR_VERSION = 1.1.11
LIBTORRENT_RASTERBAR_SITE = https://github.com/arvidn/libtorrent/releases/download/libtorrent_$(subst .,_,$(LIBTORRENT_RASTERBAR_VERSION))
LIBTORRENT_RASTERBAR_LICENSE = BSD-3-Clause
LIBTORRENT_RASTERBAR_LICENSE_FILES = COPYING
LIBTORRENT_RASTERBAR_DEPENDENCIES = host-pkgconf boost openssl
LIBTORRENT_RASTERBAR_INSTALL_STAGING = YES
LIBTORRENT_RASTERBAR_CONF_OPTS = \
	--with-boost-libdir=$(STAGING_DIR)/usr/lib \
	--disable-invariant-checks
LIBTORRENT_RASTERBAR_CONF_ENV += CXXFLAGS="$(TARGET_CXXFLAGS) -std=c++11"

ifeq ($(BR2_ENABLE_LOCALE)$(BR2_PACKAGE_LIBICONV),y)
LIBTORRENT_RASTERBAR_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)
LIBTORRENT_RASTERBAR_CONF_OPTS += --with-libiconv
else
LIBTORRENT_RASTERBAR_CONF_OPTS += --without-libiconv
endif

$(eval $(autotools-package))
