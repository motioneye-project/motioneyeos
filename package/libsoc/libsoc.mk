################################################################################
#
# libsoc
#
################################################################################

LIBSOC_VERSION = 0.6
LIBSOC_SITE = $(call github,jackmitch,libsoc,$(LIBSOC_VERSION))
LIBSOC_LICENSE = LGPLv2.1
LIBSOC_LICENSE_FILES = COPYING
LIBSOC_AUTORECONF = YES
LIBSOC_INSTALL_STAGING = YES
LIBSOC_CONF_OPT = --disable-debug

$(eval $(autotools-package))
