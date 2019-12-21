################################################################################
#
# libvdpau
#
################################################################################

LIBVDPAU_VERSION = 1.3
LIBVDPAU_SOURCE = libvdpau-$(LIBVDPAU_VERSION).tar.bz2
LIBVDPAU_SITE = \
	https://gitlab.freedesktop.org/vdpau/libvdpau/-/archive/$(LIBVDPAU_VERSION)
LIBVDPAU_LICENSE = MIT
LIBVDPAU_LICENSE_FILES = COPYING
LIBVDPAU_INSTALL_STAGING = YES

LIBVDPAU_DEPENDENCIES = host-pkgconf xlib_libX11 xlib_libXext

LIBVDPAU_CONF_OPTS = \
	-Ddocumentation=false \
	-Dmoduledir=/usr/lib/vdpau

ifeq ($(BR2_PACKAGE_XORGPROTO),y)
LIBVDPAU_DEPENDENCIES += xorgproto
LIBVDPAU_CONF_OPTS += -Ddri2=true
else
LIBVDPAU_CONF_OPTS += -Ddri2=false
endif

$(eval $(meson-package))
