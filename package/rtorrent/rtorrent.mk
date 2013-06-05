################################################################################
#
# rtorrent
#
################################################################################

RTORRENT_VERSION = 0.9.3
RTORRENT_SITE = http://libtorrent.rakshasa.no/downloads
RTORRENT_DEPENDENCIES = host-pkgconf libcurl libsigc libtorrent ncurses
RTORRENT_AUTORECONF = YES
RTORRENT_LICENSE = GPLv2
RTORRENT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
