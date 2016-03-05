################################################################################
#
# rtorrent
#
################################################################################

RTORRENT_VERSION = 0.9.6
RTORRENT_SITE = http://rtorrent.net/downloads
RTORRENT_DEPENDENCIES = host-pkgconf libcurl libtorrent ncurses
RTORRENT_AUTORECONF = YES
RTORRENT_LICENSE = GPLv2
RTORRENT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
