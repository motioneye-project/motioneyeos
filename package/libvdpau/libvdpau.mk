################################################################################
#
# libvdpau
#
################################################################################

LIBVDPAU_VERSION = 1.1.1
LIBVDPAU_SOURCE = libvdpau-$(LIBVDPAU_VERSION).tar.bz2
LIBVDPAU_SITE = http://people.freedesktop.org/~aplattner/vdpau
LIBVDPAU_LICENSE = MIT
LIBVDPAU_LICENSE_FILES = COPYING
LIBVDPAU_INSTALL_STAGING = YES

# autoreconf for patch 0002-link-with-libx11.patch
LIBVDPAU_AUTORECONF = YES

LIBVDPAU_DEPENDENCIES = host-pkgconf xlib_libX11 xlib_libXext

LIBVDPAU_CONF_OPTS = --with-module-dir=/usr/lib/vdpau

ifeq ($(BR2_PACKAGE_XORGPROTO),y)
LIBVDPAU_DEPENDENCIES += xorgproto
LIBVDPAU_CONF_OPTS += --enable-dri2
else
LIBVDPAU_CONF_OPTS += --disable-dri2
endif

$(eval $(autotools-package))
