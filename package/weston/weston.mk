################################################################################
#
# weston
#
################################################################################

WESTON_VERSION = 1.2.2
WESTON_SITE = http://wayland.freedesktop.org/releases/
WESTON_SOURCE = weston-$(WESTON_VERSION).tar.xz
WESTON_LICENSE = MIT
WESTON_LICENSE_FILES = COPYING

WESTON_DEPENDENCIES = host-pkgconf wayland libxkbcommon pixman libpng \
	jpeg mtdev udev cairo

# We touch configure.ac with one of our patches
WESTON_AUTORECONF = YES

WESTON_CONF_OPT = \
	--disable-egl \
	--disable-simple-egl-clients \
	--disable-xwayland \
	--disable-x11-compositor \
	--disable-drm-compositor \
	--disable-wayland-compositor \
	--disable-headless-compositor \
	--disable-rpi-compositor \
	--disable-weston-launch \
	--disable-libunwind

ifeq ($(BR2_PACKAGE_WESTON_FBDEV),y)
WESTON_CONF_OPT += --enable-fbdev-compositor
else
WESTON_CONF_OPT += --disable-fbdev-compositor
endif

$(eval $(autotools-package))
