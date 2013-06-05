################################################################################
#
# libdrm
#
################################################################################

LIBDRM_VERSION = 2.4.38
LIBDRM_SOURCE = libdrm-$(LIBDRM_VERSION).tar.bz2
LIBDRM_SITE = http://dri.freedesktop.org/libdrm/
LIBDRM_LICENSE = MIT

LIBDRM_INSTALL_STAGING = YES

LIBDRM_DEPENDENCIES = \
	xproto_glproto \
	xproto_xf86vidmodeproto \
	xlib_libXxf86vm \
	xlib_libXmu \
	xlib_libpciaccess \
	xproto_dri2proto \
	xlib_libpthread-stubs \
	host-pkgconf

ifeq ($(BR2_PACKAGE_XDRIVER_XF86_VIDEO_INTEL),y)
LIBDRM_CONF_OPT += --enable-intel
LIBDRM_DEPENDENCIES += libatomic_ops
else
LIBDRM_CONF_OPT += --disable-intel
endif

ifneq ($(BR2_PACKAGE_XDRIVER_XF86_VIDEO_ATI),y)
LIBDRM_CONF_OPT += --disable-radeon
endif

ifeq ($(BR2_PACKAGE_UDEV),y)
LIBDRM_CONF_OPT += --enable-udev
LIBDRM_DEPENDENCIES += udev
else
LIBDRM_CONF_OPT += --disable-udev
endif

$(eval $(autotools-package))
