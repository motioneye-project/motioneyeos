#############################################################
#
# libtorrent
#
#############################################################

LIBTORRENT_VERSION = 0.13.2
LIBTORRENT_SITE = http://libtorrent.rakshasa.no/downloads
LIBTORRENT_DEPENDENCIES = host-pkgconf libsigc \
	$(if $(BR2_PACKAGE_OPENSSL),openssl)
LIBTORRENT_CONF_OPT = --enable-aligned \
	$(if $(BR2_PACKAGE_OPENSSL),--enable-openssl,--disable-openssl)
LIBTORRENT_INSTALL_STAGING = YES
LIBTORRENT_AUTORECONF = YES

$(eval $(autotools-package))
