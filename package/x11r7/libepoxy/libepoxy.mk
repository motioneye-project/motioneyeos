################################################################################
#
# libepoxy
#
################################################################################

LIBEPOXY_VERSION = v1.3.1
LIBEPOXY_SITE = $(call github,anholt,libepoxy,$(LIBEPOXY_VERSION))
LIBEPOXY_INSTALL_STAGING = YES
LIBEPOXY_AUTORECONF = YES
LIBEPOXY_DEPENDENCIES = xlib_libX11 xutil_util-macros libegl \
	$(if $(BR2_PACKAGE_HAS_LIBGL),libgl) host-pkgconf
LIBEPOXY_LICENSE = MIT
LIBEPOXY_LICENSE_FILES = COPYING

$(eval $(autotools-package))
