################################################################################
#
# zeromq
#
################################################################################

ZEROMQ_VERSION = 4.0.4
ZEROMQ_SITE = http://download.zeromq.org/
ZEROMQ_INSTALL_STAGING = YES
ZEROMQ_DEPENDENCIES = util-linux
ZEROMQ_LICENSE = LGPLv3+ with exceptions
ZEROMQ_LICENSE_FILES = COPYING COPYING.LESSER
ZEROMQ_AUTORECONF = YES

# Only tools/curve_keygen.c needs this, but it doesn't hurt to pass it
# for the rest of the build as well (which automatically includes stdc++).
ifeq ($(BR2_PREFER_STATIC_LIB),y)
	ZEROMQ_CONF_OPT += LIBS=-lstdc++
endif

ifeq ($(BR2_PACKAGE_ZEROMQ_PGM),y)
	ZEROMQ_DEPENDENCIES += host-pkgconf openpgm
	ZEROMQ_CONF_OPT += --with-system-pgm
endif

$(eval $(autotools-package))
