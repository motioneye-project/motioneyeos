################################################################################
#
# weston
#
################################################################################

WESTON_VERSION = 1.10.0
WESTON_SITE = http://wayland.freedesktop.org/releases
WESTON_SOURCE = weston-$(WESTON_VERSION).tar.xz
WESTON_LICENSE = MIT
WESTON_LICENSE_FILES = COPYING

WESTON_DEPENDENCIES = host-pkgconf wayland wayland-protocols \
	libxkbcommon pixman libpng jpeg mtdev udev cairo libinput

WESTON_CONF_OPTS = \
	--with-dtddir=$(STAGING_DIR)/usr/share/wayland \
	--disable-simple-egl-clients \
	--disable-xwayland \
	--disable-x11-compositor \
	--disable-wayland-compositor \
	--disable-headless-compositor \
	--disable-colord \
	--disable-setuid-install

WESTON_MAKE_OPTS = \
	WAYLAND_PROTOCOLS_DATADIR=$(STAGING_DIR)/usr/share/wayland-protocols

# weston-launch must be u+s root in order to work properly
ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
define WESTON_PERMISSIONS
	/usr/bin/weston-launch f 4755 0 0 - - - - -
endef
define WESTON_USERS
	- - weston-launch -1 - - - - Weston launcher group
endef
WESTON_CONF_OPTS += --enable-weston-launch
WESTON_DEPENDENCIES += linux-pam
else
WESTON_CONF_OPTS += --disable-weston-launch
endif

# Needs wayland-egl, which normally only mesa provides
ifeq ($(BR2_PACKAGE_HAS_LIBEGL)$(BR2_PACKAGE_MESA3D_OPENGL_EGL),yy)
WESTON_CONF_OPTS += --enable-egl
WESTON_DEPENDENCIES += libegl
else
WESTON_CONF_OPTS += --disable-egl
endif

ifeq ($(BR2_PACKAGE_LIBUNWIND),y)
WESTON_DEPENDENCIES += libunwind
else
WESTON_CONF_OPTS += --disable-libunwind
endif

ifeq ($(BR2_PACKAGE_WESTON_RDP),y)
WESTON_DEPENDENCIES += freerdp
WESTON_CONF_OPTS += --enable-rdp-compositor
else
WESTON_CONF_OPTS += --disable-rdp-compositor
endif

ifeq ($(BR2_PACKAGE_WESTON_FBDEV),y)
WESTON_CONF_OPTS += \
	--enable-fbdev-compositor \
	WESTON_NATIVE_BACKEND=fbdev-backend.so
else
WESTON_CONF_OPTS += --disable-fbdev-compositor
endif

ifeq ($(BR2_PACKAGE_WESTON_DRM),y)
WESTON_CONF_OPTS += \
	--enable-drm-compositor \
	WESTON_NATIVE_BACKEND=drm-backend.so
WESTON_DEPENDENCIES += libdrm
else
WESTON_CONF_OPTS += --disable-drm-compositor
endif

ifeq ($(BR2_PACKAGE_WESTON_RPI),y)
WESTON_DEPENDENCIES += rpi-userland
WESTON_CONF_OPTS += --enable-rpi-compositor \
	--disable-resize-optimization \
	--disable-xwayland-test \
	WESTON_NATIVE_BACKEND=rpi-backend.so
else
WESTON_CONF_OPTS += --disable-rpi-compositor
endif # BR2_PACKAGE_WESTON_RPI

ifeq ($(BR2_PACKAGE_LIBVA),y)
WESTON_CONF_OPTS += --enable-vaapi-recorder
WESTON_DEPENDENIES += libva
else
WESTON_CONF_OPTS += --disable-vaapi-recorder
endif

$(eval $(autotools-package))
