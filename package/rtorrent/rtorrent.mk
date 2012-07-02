#############################################################
#
# rtorrent
#
#############################################################

RTORRENT_VERSION = 0.9.2
RTORRENT_SITE = http://libtorrent.rakshasa.no/downloads
RTORRENT_DEPENDENCIES = host-pkg-config libcurl libsigc libtorrent ncurses
RTORRENT_AUTORECONF = YES

$(eval $(autotools-package))
