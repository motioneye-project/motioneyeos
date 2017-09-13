################################################################################
#
# ncmpc
#
################################################################################

NCMPC_VERSION_MAJOR = 0
NCMPC_VERSION = $(NCMPC_VERSION_MAJOR).27
NCMPC_SOURCE = ncmpc-$(NCMPC_VERSION).tar.xz
NCMPC_SITE = http://www.musicpd.org/download/ncmpc/$(NCMPC_VERSION_MAJOR)
NCMPC_DEPENDENCIES = host-pkgconf libglib2 libmpdclient ncurses
NCMPC_LICENSE = GPL-2.0+
NCMPC_LICENSE_FILES = COPYING

$(eval $(autotools-package))
