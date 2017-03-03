################################################################################
#
# memtool
#
################################################################################

MEMTOOL_VERSION = 2016.10.0
MEMTOOL_SITE = http://public.pengutronix.de/software/memtool
MEMTOOL_SOURCE = memtool-$(MEMTOOL_VERSION).tar.xz
MEMTOOL_LICENSE = GPLv2
MEMTOOL_LICENSE_FILES = COPYING

$(eval $(autotools-package))
