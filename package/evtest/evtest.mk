################################################################################
#
# evtest
#
################################################################################

EVTEST_VERSION = 1.31
EVTEST_SOURCE = evtest-$(EVTEST_VERSION).tar.gz
EVTEST_SITE = http://cgit.freedesktop.org/evtest/snapshot
EVTEST_LICENSE = GPLv2+
EVTEST_LICENSE_FILES = COPYING
EVTEST_DEPENDENCIES = host-pkgconf
# needed because source package contains no generated files
EVTEST_AUTORECONF = YES

$(eval $(autotools-package))
