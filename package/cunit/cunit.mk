################################################################################
#
# cunit
#
################################################################################

CUNIT_VERSION = 2.1-3
CUNIT_SITE = http://downloads.sourceforge.net/project/cunit/CUnit/$(CUNIT_VERSION)
CUNIT_SOURCE = CUnit-$(CUNIT_VERSION).tar.bz2
CUNIT_INSTALL_STAGING = YES
CUNIT_LICENSE = LGPL-2.0+
CUNIT_LICENSE_FILES = COPYING

# The source archive does not have the autoconf/automake material generated.
CUNIT_AUTORECONF = YES

$(eval $(autotools-package))
