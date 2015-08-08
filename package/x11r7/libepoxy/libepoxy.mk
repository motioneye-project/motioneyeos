################################################################################
#
# libepoxy
#
################################################################################

LIBEPOXY_VERSION = v1.2
LIBEPOXY_SITE = $(call github,anholt,libepoxy,$(LIBEPOXY_VERSION))
LIBEPOXY_INSTALL_STAGING = YES
LIBEPOXY_AUTORECONF = YES
LIBEPOXY_DEPENDENCIES = xlib_libX11 xutil_util-macros libegl \
	$(if $(BR2_PACKAGE_HAS_LIBGL),libgl)
LIBEPOXY_LICENSE = MIT
LIBEPOXY_LICENSE_FILES = COPYING

# needed for rpi-userland
LIBEPOXY_CFLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags egl`
LIBEPOXY_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) $(LIBEPOXY_CFLAGS)"

$(eval $(autotools-package))
