################################################################################
#
# xapian
#
################################################################################

XAPIAN_VERSION = 1.4.7
XAPIAN_SOURCE = xapian-core-$(XAPIAN_VERSION).tar.xz
XAPIAN_SITE = https://oligarchy.co.uk/xapian/$(XAPIAN_VERSION)
XAPIAN_LICENSE = GPL-2.0+
XAPIAN_LICENSE_FILES = COPYING
XAPIAN_INSTALL_STAGING = YES
XAPIAN_DEPENDENCIES = zlib

$(eval $(autotools-package))
