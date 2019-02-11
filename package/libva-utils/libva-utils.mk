################################################################################
#
# libva-utils
#
################################################################################

LIBVA_UTILS_VERSION = 2.4.0
LIBVA_UTILS_SOURCE = libva-utils-$(LIBVA_UTILS_VERSION).tar.bz2
LIBVA_UTILS_SITE = https://github.com/intel/libva-utils/releases/download/$(LIBVA_UTILS_VERSION)
LIBVA_UTILS_LICENSE = MIT
LIBVA_UTILS_LICENSE_FILES = COPYING
# 0001-check-ssp.patch
# 0002-Fix-build-failure-when-x11-support-is-disabled.patch
LIBVA_UTILS_AUTORECONF = YES
LIBVA_UTILS_DEPENDENCIES = host-pkgconf libva

define LIBVA_UTILS_CREATE_M4_DIR
	@mkdir -p $(@D)/m4
endef

LIBVA_UTILS_POST_EXTRACT_HOOKS += LIBVA_UTILS_CREATE_M4_DIR

$(eval $(autotools-package))
