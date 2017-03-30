################################################################################
#
# libshairplay
#
################################################################################

LIBSHAIRPLAY_VERSION = ce80e005908f41d0e6fde1c4a21e9cb8ee54007b
LIBSHAIRPLAY_SITE = $(call github,juhovh,shairplay,$(LIBSHAIRPLAY_VERSION))
LIBSHAIRPLAY_INSTALL_STAGING = YES
LIBSHAIRPLAY_AUTORECONF = YES
LIBSHAIRPLAY_LICENSE = MIT, BSD-3-Clause, LGPL-2.1+
LIBSHAIRPLAY_LICENSE_FILES = LICENSE
LIBSHAIRPLAY_DEPENDENCIES = host-pkgconf $(if $(BR2_PACKAGE_LIBAO),libao)

$(eval $(autotools-package))
