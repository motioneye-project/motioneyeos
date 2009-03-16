################################################################################
#
# xserver_xorg-server -- No description available
#
################################################################################

XSERVER_XORG_SERVER_VERSION = 1.5.2
XSERVER_XORG_SERVER_SOURCE = xorg-server-$(XSERVER_XORG_SERVER_VERSION).tar.bz2
XSERVER_XORG_SERVER_SITE = http://xorg.freedesktop.org/releases/individual/xserver
XSERVER_XORG_SERVER_AUTORECONF = NO
XSERVER_XORG_SERVER_INSTALL_STAGING = YES
XSERVER_XORG_SERVER_USE_CONFIG_CACHE = NO # overrides CFLAGS
XSERVER_XORG_SERVER_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) install install-data

XSERVER_XORG_SERVER_DEPENDENCIES =  freetype xutil_util-macros xlib_libXfont libdrm xlib_libxkbui openssl \
									xproto_compositeproto xproto_damageproto xproto_fixesproto \
									xproto_glproto xproto_kbproto xproto_randrproto \
									xlib_libX11 xlib_libXau xlib_libXaw xlib_libXdmcp xlib_libXScrnSaver \
									xlib_libXext xlib_libXfixes xlib_libXi xlib_libXmu xlib_libXpm \
									xlib_libXrender xlib_libXres xlib_libXtst xlib_libXft xlib_libXcursor \
									xlib_libXinerama xlib_libXrandr xlib_libXdamage xlib_libXxf86misc xlib_libXxf86vm \
									xlib_liblbxutil xlib_libxkbfile xlib_xtrans xdata_xbitmaps xproto_bigreqsproto \
									xproto_evieext xproto_fontsproto xproto_inputproto xproto_recordproto xproto_renderproto \
									xproto_resourceproto xproto_trapproto xproto_videoproto xproto_xcmiscproto \
									xproto_xextproto xproto_xf86bigfontproto xproto_xf86dgaproto xproto_xf86driproto \
									xproto_xf86miscproto xproto_xf86rushproto xproto_xf86vidmodeproto xproto_xproto \
									pixman dbus mcookie

XSERVER_XORG_SERVER_CONF_OPT = --enable-freetype --disable-config-hal \
		--disable-xnest --disable-xephyr --disable-xvfb \
		CFLAGS="-I$(STAGING_DIR)/usr/include/pixman-1"

ifeq ($(BR2_PACKAGE_XSERVER_xorg),y)
XSERVER_XORG_SERVER_DEPENDENCIES += mesa3d
XSERVER_XORG_SERVER_CONF_OPT += --with-mesa-source="$(BUILD_DIR)/Mesa-$(MESA3D_VERSION)" --enable-xorg
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-xorg
endif

ifeq ($(BR2_PACKAGE_XSERVER_tinyx),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-kdrive --enable-xfbdev --disable-glx --disable-dri
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-kdrive --disable-xfbdev
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_NULL_CURSOR),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-null-root-cursor
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-null-root-cursor
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_BUILTIN_FONTS),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-builtin-fonts
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-builtin-fonts
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_AIGLX),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-aiglx
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-aiglx
endif

# Optional packages
ifeq ($(BR2_PACKAGE_TSLIB),y)
XSERVER_XORG_SERVER_DEPENDENCIES += tslib
XSERVER_XORG_SERVER_CONF_OPT += --enable-tslib LDFLAGS="-lts"
endif

$(eval $(call AUTOTARGETS,package/x11r7,xserver_xorg-server))
