################################################################################
#
# autoconf-archive
#
################################################################################

AUTOCONF_ARCHIVE_VERSION = 2016.03.20
AUTOCONF_ARCHIVE_SOURCE = autoconf-archive-$(AUTOCONF_ARCHIVE_VERSION).tar.xz
AUTOCONF_ARCHIVE_SITE = $(BR2_GNU_MIRROR)/autoconf-archive
AUTOCONF_ARCHIVE_LICENSE = GPLv3+ with exception
AUTOCONF_ARCHIVE_LICENSE_FILES = COPYING COPYING.EXCEPTION
HOST_AUTOCONF_ARCHIVE_INSTALL_OPTS = aclocaldir=$(HOST_DIR)/usr/share/autoconf-archive install

$(eval $(host-autotools-package))
