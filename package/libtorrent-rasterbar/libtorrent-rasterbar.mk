################################################################################
#
# libtorrent-rasterbar
#
################################################################################

LIBTORRENT_RASTERBAR_VERSION = 1.2.4
LIBTORRENT_RASTERBAR_SITE = https://github.com/arvidn/libtorrent/releases/download/libtorrent-$(subst .,_,$(LIBTORRENT_RASTERBAR_VERSION))
LIBTORRENT_RASTERBAR_LICENSE = BSD-3-Clause
LIBTORRENT_RASTERBAR_LICENSE_FILES = COPYING
LIBTORRENT_RASTERBAR_DEPENDENCIES = host-pkgconf boost openssl
LIBTORRENT_RASTERBAR_INSTALL_STAGING = YES
LIBTORRENT_RASTERBAR_CONF_OPTS = \
	--with-boost-libdir=$(STAGING_DIR)/usr/lib \
	--disable-invariant-checks
LIBTORRENT_RASTERBAR_CXXFLAGS = $(TARGET_CXXFLAGS) -std=c++11

# Internal error, aborting at dwarf2cfi.c:2802 in connect_traces
# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58864
ifeq ($(BR2_m68k_cf),y)
LIBTORRENT_RASTERBAR_CXXFLAGS += -fno-defer-pop
endif

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
LIBTORRENT_RASTERBAR_CXXFLAGS += -O0
endif

LIBTORRENT_RASTERBAR_CONF_OPTS += CXXFLAGS="$(LIBTORRENT_RASTERBAR_CXXFLAGS)"

ifeq ($(BR2_ENABLE_LOCALE)$(BR2_PACKAGE_LIBICONV),y)
LIBTORRENT_RASTERBAR_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)
LIBTORRENT_RASTERBAR_CONF_OPTS += --with-libiconv
else
LIBTORRENT_RASTERBAR_CONF_OPTS += --without-libiconv
endif

$(eval $(autotools-package))
