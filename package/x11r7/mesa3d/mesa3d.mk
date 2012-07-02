#############################################################
#
# mesa3d
#
#############################################################

MESA3D_VERSION = 7.6.1
MESA3D_SOURCE = MesaLib-$(MESA3D_VERSION).tar.gz
MESA3D_SITE = ftp://ftp.freedesktop.org/pub/mesa/$(MESA3D_VERSION)
MESA3D_INSTALL_STAGING = YES

MESA3D_CONF_OPT = \
	--disable-egl \
	--disable-glu \
	--disable-glw \
	--disable-glut \
	--disable-gallium \
	--with-driver=dri \
	--with-dri-drivers=swrast \
	--disable-static

MESA3D_DEPENDENCIES = \
	xproto_glproto \
	xlib_libXxf86vm \
	xlib_libXdamage \
	xlib_libXfixes \
	xproto_dri2proto \
	libdrm \
	expat

$(eval $(autotools-package))
