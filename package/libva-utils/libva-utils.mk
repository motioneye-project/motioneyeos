################################################################################
#
# libva-utils
#
################################################################################

LIBVA_UTILS_VERSION = 2.7.1
LIBVA_UTILS_SITE = $(call github,intel,libva-utils,$(LIBVA_UTILS_VERSION))
LIBVA_UTILS_LICENSE = MIT
LIBVA_UTILS_LICENSE_FILES = COPYING
# github tarball does not include configure
LIBVA_UTILS_AUTORECONF = YES
LIBVA_UTILS_DEPENDENCIES = host-pkgconf libva

$(eval $(autotools-package))
