################################################################################
#
# zeromq
#
################################################################################

ZEROMQ_VERSION = 4.0.5
ZEROMQ_SITE = http://download.zeromq.org
ZEROMQ_INSTALL_STAGING = YES
ZEROMQ_DEPENDENCIES = util-linux
ZEROMQ_LICENSE = LGPLv3+ with exceptions
ZEROMQ_LICENSE_FILES = COPYING COPYING.LESSER
# For 0001-tests-disable-test_fork-if-fork-is-not-available.patch
ZEROMQ_AUTORECONF = YES

# Only tools/curve_keygen.c needs this, but it doesn't hurt to pass it
# for the rest of the build as well (which automatically includes stdc++).
ifeq ($(BR2_STATIC_LIBS),y)
	ZEROMQ_CONF_OPTS += LIBS=-lstdc++
endif

ifeq ($(BR2_PACKAGE_ZEROMQ_PGM),y)
	ZEROMQ_DEPENDENCIES += host-pkgconf openpgm
	ZEROMQ_CONF_OPTS += --with-system-pgm
endif

$(eval $(autotools-package))
