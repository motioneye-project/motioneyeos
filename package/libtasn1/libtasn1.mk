################################################################################
#
# libtasn1
#
################################################################################

LIBTASN1_VERSION = 4.16.0
LIBTASN1_SITE = $(BR2_GNU_MIRROR)/libtasn1
LIBTASN1_DEPENDENCIES = host-bison host-pkgconf
LIBTASN1_LICENSE = GPL-3.0+ (tests, tools), LGPL-2.1+ (library)
LIBTASN1_LICENSE_FILES = LICENSE doc/COPYING doc/COPYING.LESSER
LIBTASN1_INSTALL_STAGING = YES

# We're patching fuzz/Makefile.am
LIBTASN1_AUTORECONF = YES

# 'missing' fallback logic botched so disable it completely
LIBTASN1_CONF_ENV = MAKEINFO="true"

LIBTASN1_CONF_OPTS = CFLAGS="$(TARGET_CFLAGS) -std=gnu99"

$(eval $(autotools-package))
