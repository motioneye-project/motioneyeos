#############################################################
#
# libdrm
#
#############################################################
LIBDRM_VERSION = 2.4.19
LIBDRM_SOURCE = libdrm-$(LIBDRM_VERSION).tar.bz2
LIBDRM_SITE = http://dri.freedesktop.org/libdrm/
LIBDRM_INSTALL_STAGING = YES

LIBDRM_DEPENDENCIES = \
	xproto_glproto \
	xproto_xf86vidmodeproto \
	xlib_libXxf86vm \
	xlib_libXmu \
	xproto_dri2proto \
	pthread-stubs \
	host-pkg-config

ifeq ($(BR2_PACKAGE_XDRIVER_XF86_VIDEO_INTEL),y)
LIBDRM_CONF_OPT += --enable-intel
LIBDRM_DEPENDENCIES += libatomic_ops
else
LIBDRM_CONF_OPT += --disable-intel
endif

ifneq ($(BR2_PACKAGE_XDRIVER_XF86_VIDEO_ATI),y)
LIBDRM_CONF_OPT += --disable-radeon
endif

$(eval $(autotools-package))
