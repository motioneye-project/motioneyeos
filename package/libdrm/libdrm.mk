#############################################################
#
# libdrm
#
#############################################################
LIBDRM_VERSION = 2.4.19
LIBDRM_SOURCE = libdrm-$(LIBDRM_VERSION).tar.bz2
LIBDRM_SITE = http://dri.freedesktop.org/libdrm/
LIBDRM_AUTORECONF = NO
LIBDRM_LIBTOOL_PATCH = NO
LIBDRM_INSTALL_STAGING = YES
LIBDRM_INSTALL_TARGET = YES

LIBDRM_DEPENDENCIES = xproto_glproto xproto_xf86vidmodeproto xlib_libXxf86vm xlib_libXmu xproto_dri2proto pthread-stubs

$(eval $(call AUTOTARGETS,package,libdrm))
