################################################################################
#
# xserver_xorg-server -- No description available
#
################################################################################

XSERVER_XORG_SERVER_VERSION = 1.7.5
XSERVER_XORG_SERVER_SOURCE = xorg-server-$(XSERVER_XORG_SERVER_VERSION).tar.bz2
XSERVER_XORG_SERVER_SITE = http://xorg.freedesktop.org/releases/individual/xserver
XSERVER_XORG_SERVER_MAKE = $(MAKE1) # make install fails with parallel make
XSERVER_XORG_SERVER_INSTALL_STAGING = YES
XSERVER_XORG_SERVER_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) install install-data
XSERVER_XORG_SERVER_AUTORECONF = YES

XSERVER_XORG_SERVER_DEPENDENCIES = 	\
	xutil_util-macros 		\
	xlib_libXfont 			\
	xlib_libX11 			\
	xlib_libXau 			\
	xlib_libXdmcp 			\
	xlib_libXext 			\
	xlib_libXfixes 			\
	xlib_libXi 			\
	xlib_libXrender 		\
	xlib_libXres 			\
	xlib_libXft 			\
	xlib_libXcursor 		\
	xlib_libXinerama 		\
	xlib_libXrandr 			\
	xlib_libXdamage 		\
	xlib_libXxf86vm 		\
	xlib_libxkbfile 		\
	xlib_xtrans 			\
	xdata_xbitmaps 			\
	xproto_bigreqsproto 		\
	xproto_compositeproto 		\
	xproto_damageproto 		\
	xproto_fixesproto 		\
	xproto_fontsproto 		\
	xproto_glproto 			\
	xproto_inputproto 		\
	xproto_kbproto 			\
	xproto_randrproto 		\
	xproto_renderproto 		\
	xproto_resourceproto 		\
	xproto_videoproto 		\
	xproto_xcmiscproto 		\
	xproto_xextproto 		\
	xproto_xf86bigfontproto 	\
	xproto_xf86dgaproto 		\
	xproto_xf86rushproto 		\
	xproto_xf86vidmodeproto 	\
	xproto_xproto 			\
	xkeyboard-config		\
	pixman 				\
	openssl 			\
	mcookie 			\
	host-pkg-config

XSERVER_XORG_SERVER_CONF_OPT = --disable-config-hal \
		--disable-xnest --disable-xephyr --disable-xvfb \
		--disable-dmx \
		--with-builder-addr=buildroot@uclibc.org \
		CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include/pixman-1" \
		--with-fontdir=/usr/share/fonts/X11/ --localstatedir=/var

ifeq ($(BR2_PACKAGE_XSERVER_xorg),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-xorg
XSERVER_XORG_SERVER_DEPENDENCIES += xlib_libpciaccess libdrm
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-xorg
endif

ifeq ($(BR2_PACKAGE_XSERVER_tinyx),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-kdrive --enable-xfbdev \
		--disable-glx --disable-dri --disable-xsdl
define XSERVER_CREATE_X_SYMLINK
 ln -f -s Xfbdev $(TARGET_DIR)/usr/bin/X
endef
XSERVER_XORG_SERVER_POST_INSTALL_TARGET_HOOKS += XSERVER_CREATE_X_SYMLINK
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-kdrive --disable-xfbdev
endif

ifeq ($(BR2_PACKAGE_MESA3D),y)
XSERVER_XORG_SERVER_DEPENDENCIES += mesa3d xproto_xf86driproto
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-dri
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_NULL_CURSOR),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-null-root-cursor
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-null-root-cursor
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

ifeq ($(BR2_PACKAGE_DBUS),y)
XSERVER_XORG_SERVER_DEPENDENCIES += dbus
XSERVER_XORG_SERVER_CONF_OPT += --enable-config-dbus
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
XSERVER_XORG_SERVER_DEPENDENCIES += freetype
endif

ifeq ($(BR2_PACKAGE_XPROTO_RECORDPROTO),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xproto_recordproto
XSERVER_XORG_SERVER_CONF_OPT += --enable-record
endif

ifneq ($(BR2_PACKAGE_XLIB_LIBXVMC),y)
XSERVER_XORG_SERVER_CONF_OPT += --disable-xvmc
endif

ifneq ($(BR2_PACKAGE_XLIB_LIBXCOMPOSITE),y)
XSERVER_XORG_SERVER_CONF_OPT += --disable-composite
endif

ifeq ($(BR2_PACKAGE_XSERVER_xorg),y)
ifeq ($(BR2_PACKAGE_XPROTO_DRI2PROTO),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xproto_dri2proto
XSERVER_XORG_SERVER_CONF_OPT += --enable-dri2
endif
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-dri2
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXSCRNSAVER),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xlib_libXScrnSaver
XSERVER_XORG_SERVER_CONF_OPT += --enable-screensaver
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-screensaver
endif

ifneq ($(BR2_PACKAGE_XLIB_LIBDMX),y)
XSERVER_XORG_SERVER_CONF_OPT += --disable-dmx
endif

ifeq ($(BR2_PACKAGE_MESA3D),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-glx
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-glx
endif

$(eval $(autotools-package))
