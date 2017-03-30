################################################################################
#
# libtorrent
#
################################################################################

LIBTORRENT_VERSION = 0.13.6
LIBTORRENT_SITE = http://rtorrent.net/downloads
LIBTORRENT_DEPENDENCIES = host-pkgconf zlib \
	$(if $(BR2_PACKAGE_OPENSSL),openssl)
LIBTORRENT_CONF_OPTS = --enable-aligned \
	--disable-instrumentation \
	--with-zlib=$(STAGING_DIR)/usr \
	$(if $(BR2_PACKAGE_OPENSSL),--enable-openssl,--disable-openssl)
LIBTORRENT_INSTALL_STAGING = YES
LIBTORRENT_AUTORECONF = YES
LIBTORRENT_LICENSE = GPL-2.0
LIBTORRENT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
