################################################################################
#
# libtorrent
#
################################################################################

LIBTORRENT_VERSION = 0.13.3
LIBTORRENT_SITE = http://libtorrent.rakshasa.no/downloads
LIBTORRENT_DEPENDENCIES = host-pkgconf libsigc \
	$(if $(BR2_PACKAGE_OPENSSL),openssl)
LIBTORRENT_CONF_OPTS = --enable-aligned \
	$(if $(BR2_PACKAGE_OPENSSL),--enable-openssl,--disable-openssl)
LIBTORRENT_INSTALL_STAGING = YES
LIBTORRENT_AUTORECONF = YES
LIBTORRENT_LICENSE = GPLv2
LIBTORRENT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
