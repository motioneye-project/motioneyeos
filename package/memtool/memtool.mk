################################################################################
#
# memtool
#
################################################################################

MEMTOOL_VERSION = 2018.03.0
MEMTOOL_SITE = http://public.pengutronix.de/software/memtool
MEMTOOL_SOURCE = memtool-$(MEMTOOL_VERSION).tar.xz
MEMTOOL_LICENSE = GPL-2.0
MEMTOOL_LICENSE_FILES = COPYING

$(eval $(autotools-package))
