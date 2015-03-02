################################################################################
#
# autoconf-archive
#
################################################################################

AUTOCONF_ARCHIVE_VERSION = 2015.02.04
AUTOCONF_ARCHIVE_SOURCE = autoconf-archive-$(AUTOCONF_ARCHIVE_VERSION).tar.xz
AUTOCONF_ARCHIVE_SITE = $(BR2_GNU_MIRROR)/autoconf-archive/
AUTOCONF_ARCHIVE_LICENSE = GPLv3+ with exception
AUTOCONF_ARCHIVE_LICENSE_FILES = COPYING COPYING.EXCEPTION

$(eval $(host-autotools-package))
