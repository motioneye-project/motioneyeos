################################################################################
#
# libtasn1
#
################################################################################

LIBTASN1_VERSION = 4.13
LIBTASN1_SITE = $(BR2_GNU_MIRROR)/libtasn1
LIBTASN1_DEPENDENCIES = host-bison
LIBTASN1_LICENSE = GPL-3.0+ (tests, tools), LGPL-2.1+ (library)
LIBTASN1_LICENSE_FILES = COPYING COPYING.LIB
LIBTASN1_INSTALL_STAGING = YES
# 'missing' fallback logic botched so disable it completely
LIBTASN1_CONF_ENV = MAKEINFO="true"

$(eval $(autotools-package))
