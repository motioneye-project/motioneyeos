#############################################################
#
# mesa3d
#
#############################################################
MESA3D_VERSION:=7.6.1
MESA3D_SOURCE:=MesaLib-$(MESA3D_VERSION).tar.gz
MESA3D_SITE:=ftp://ftp.freedesktop.org/pub/mesa/$(MESA3D_VERSION)

MESA3D_AUTORECONF = NO
MESA3D_CONF_OPT = --disable-egl --disable-glu --disable-glw --disable-glut --disable-gallium --with-driver=dri --with-dri-drivers=swrast
MESA3D_INSTALL_STAGING = YES

MESA3D_DEPENDENCIES = xproto_glproto xlib_libXxf86vm xlib_libXdamage xlib_libXfixes xproto_dri2proto libdrm expat

$(eval $(call AUTOTARGETS,package/x11r7,mesa3d))
