################################################################################
#
# libepoxy
#
################################################################################

LIBEPOXY_VERSION = v1.3.1
LIBEPOXY_SITE = $(call github,anholt,libepoxy,$(LIBEPOXY_VERSION))
LIBEPOXY_INSTALL_STAGING = YES
# For patches 0001-0006:
LIBEPOXY_AUTORECONF = YES
LIBEPOXY_DEPENDENCIES = xutil_util-macros
LIBEPOXY_LICENSE = MIT
LIBEPOXY_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_HAS_LIBEGL),y)
LIBEPOXY_CONF_OPTS += --enable-egl
LIBEPOXY_DEPENDENCIES += libegl
else
LIBEPOXY_CONF_OPTS += --disable-egl
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGL)$(BR2_PACKAGE_XLIB_LIBX11),yy)
LIBEPOXY_CONF_OPTS += --enable-glx
LIBEPOXY_DEPENDENCIES += libgl xlib_libX11
else
LIBEPOXY_CONF_OPTS += --disable-glx
endif

$(eval $(autotools-package))
