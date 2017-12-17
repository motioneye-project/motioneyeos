################################################################################
#
# nload
#
################################################################################

NLOAD_VERSION = 0.7.4
NLOAD_SITE = http://www.roland-riegel.de/nload
NLOAD_DEPENDENCIES = ncurses
NLOAD_LICENSE = GPL-2.0+
NLOAD_LICENSE_FILES = COPYING

$(eval $(autotools-package))
