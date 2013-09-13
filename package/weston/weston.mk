################################################################################
#
# weston
#
################################################################################

WESTON_VERSION = 1.1.0
WESTON_SITE = http://wayland.freedesktop.org/releases/
WESTON_SOURCE = weston-$(WAYLAND_VERSION).tar.xz
WESTON_LICENSE = MIT
WESTON_LICENSE_FILES = COPYING

WESTON_DEPENDENCIES = wayland libxkbcommon pixman libpng \
	jpeg mtdev udev cairo
WESTON_CONF_OPT = \
	--disable-egl \
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
