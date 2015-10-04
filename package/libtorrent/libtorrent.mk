################################################################################
#
# libtorrent
#
################################################################################

LIBTORRENT_VERSION = 0.13.6
LIBTORRENT_SITE = http://rtorrent.net/downloads
LIBTORRENT_DEPENDENCIES = host-pkgconf libsigc \
	$(if $(BR2_PACKAGE_OPENSSL),openssl) \
	$(if $(BR2_PACKAGE_ZLIB),zlib)
LIBTORRENT_CONF_OPTS = --enable-aligned \
	--disable-instrumentation \
	$(if $(BR2_PACKAGE_OPENSSL),--enable-openssl,--disable-openssl) \
	$(if $(BR2_PACKAGE_ZLIB),--with-zlib=$(STAGING_DIR)/usr,--without-zlib)
LIBTORRENT_INSTALL_STAGING = YES
LIBTORRENT_AUTORECONF = YES
LIBTORRENT_LICENSE = GPLv2
LIBTORRENT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
