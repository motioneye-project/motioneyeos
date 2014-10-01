################################################################################
#
# libshairplay
#
################################################################################

LIBSHAIRPLAY_VERSION = 64d59e3087f829006d091fa0d114efb50972a2bf
LIBSHAIRPLAY_SITE = $(call github,juhovh,shairplay,$(LIBSHAIRPLAY_VERSION))
LIBSHAIRPLAY_INSTALL_STAGING = YES
LIBSHAIRPLAY_AUTORECONF = YES
LIBSHAIRPLAY_LICENSE = MIT, BSD-3c, LGPLv2.1+
LIBSHAIRPLAY_LICENSE_FILES = LICENSE
LIBSHAIRPLAY_DEPENDENCIES = host-pkgconf $(if $(BR2_PACKAGE_LIBAO),libao)

$(eval $(autotools-package))
