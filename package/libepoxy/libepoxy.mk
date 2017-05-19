################################################################################
#
# libepoxy
#
################################################################################

LIBEPOXY_VERSION_MAJOR = 1.4
LIBEPOXY_VERSION = $(LIBEPOXY_VERSION_MAJOR).1
LIBEPOXY_SITE = http://ftp.gnome.org/pub/gnome/sources/libepoxy/$(LIBEPOXY_VERSION_MAJOR)
LIBEPOXY_SOURCE = libepoxy-$(LIBEPOXY_VERSION).tar.xz
LIBEPOXY_INSTALL_STAGING = YES
LIBEPOXY_DEPENDENCIES = host-pkgconf xutil_util-macros
LIBEPOXY_LICENSE = MIT
LIBEPOXY_LICENSE_FILES = COPYING
# 0002-Make-EGL-support-optional.patch
LIBEPOXY_AUTORECONF = YES

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
