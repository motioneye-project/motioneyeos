################################################################################
#
# weston
#
################################################################################

ifeq ($(BR2_PACKAGE_IMX_GPU_VIV_OUTPUT_WL),y)
WESTON_VERSION = rel_imx_4.9.51_8mq_ga
WESTON_SITE = https://source.codeaurora.org/external/imx/weston-imx
WESTON_SITE_METHOD = git
WESTON_AUTORECONF = YES
else
WESTON_VERSION = 5.0.0
WESTON_SITE = http://wayland.freedesktop.org/releases
WESTON_SOURCE = weston-$(WESTON_VERSION).tar.xz
endif
WESTON_LICENSE = MIT
WESTON_LICENSE_FILES = COPYING

WESTON_DEPENDENCIES = host-pkgconf wayland wayland-protocols \
	libxkbcommon pixman libpng jpeg udev cairo libinput libdrm \
	$(if $(BR2_PACKAGE_WEBP),webp)

WESTON_CONF_OPTS = \
	--with-dtddir=$(STAGING_DIR)/usr/share/wayland \
	--disable-headless-compositor \
	--disable-colord \
	--disable-devdocs \
	--disable-setuid-install

WESTON_MAKE_OPTS = \
	WAYLAND_PROTOCOLS_DATADIR=$(STAGING_DIR)/usr/share/wayland-protocols

# Uses VIDIOC_EXPBUF, only available from 3.8+
ifeq ($(BR2_TOOLCHAIN_HEADERS_AT_LEAST_3_8),)
WESTON_CONF_OPTS += --disable-simple-dmabuf-v4l-client
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
WESTON_CONF_OPTS += --enable-dbus
WESTON_DEPENDENCIES += dbus
else
WESTON_CONF_OPTS += --disable-dbus
endif

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

ifeq ($(BR2_PACKAGE_IMX_GPU_VIV_OUTPUT_WL),y)
ifeq ($(BR2_PACKAGE_IMX_GPU_G2D),y)
WESTON_DEPENDENCIES += imx-gpu-g2d
# --enable-imxg2d actually disables it, so no CONF_OPTS
else
WESTON_CONF_OPTS += --disable-imxg2d
endif
endif

ifeq ($(BR2_PACKAGE_HAS_LIBEGL_WAYLAND)$(BR2_PACKAGE_HAS_LIBGLES),yy)
WESTON_CONF_OPTS += --enable-egl
WESTON_DEPENDENCIES += libegl libgles
else
WESTON_CONF_OPTS += \
	--disable-egl \
	--disable-simple-dmabuf-drm-client \
	--disable-simple-egl-clients
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
else
WESTON_CONF_OPTS += --disable-drm-compositor
endif

ifeq ($(BR2_PACKAGE_WESTON_X11),y)
WESTON_CONF_OPTS += \
	--enable-x11-compositor \
	WESTON_NATIVE_BACKEND=x11-backend.so
WESTON_DEPENDENCIES += libxcb xlib_libX11
else
WESTON_CONF_OPTS += --disable-x11-compositor
endif

ifeq ($(BR2_PACKAGE_WESTON_XWAYLAND),y)
WESTON_CONF_OPTS += --enable-xwayland
WESTON_DEPENDENCIES += cairo libepoxy libxcb xlib_libX11 xlib_libXcursor
else
WESTON_CONF_OPTS += --disable-xwayland
endif

ifeq ($(BR2_PACKAGE_LIBVA),y)
WESTON_CONF_OPTS += --enable-vaapi-recorder
WESTON_DEPENDENCIES += libva
else
WESTON_CONF_OPTS += --disable-vaapi-recorder
endif

ifeq ($(BR2_PACKAGE_LCMS2),y)
WESTON_CONF_OPTS += --enable-lcms
WESTON_DEPENDENCIES += lcms2
else
WESTON_CONF_OPTS += --disable-lcms
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
WESTON_CONF_OPTS += --enable-systemd-login --enable-systemd-notify
WESTON_DEPENDENCIES += systemd
else
WESTON_CONF_OPTS += --disable-systemd-login --disable-systemd-notify
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
WESTON_CONF_OPTS += --enable-junit-xml
WESTON_DEPENDENCIES += libxml2
else
WESTON_CONF_OPTS += --disable-junit-xml
endif

ifeq ($(BR2_PACKAGE_WESTON_DEMO_CLIENTS),y)
WESTON_CONF_OPTS += --enable-demo-clients-install
else
WESTON_CONF_OPTS += --disable-demo-clients-install
endif

$(eval $(autotools-package))
