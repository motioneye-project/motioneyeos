################################################################################
#
# xserver_xorg-server
#
################################################################################

XSERVER_XORG_SERVER_VERSION = $(call qstrip,$(BR2_PACKAGE_XSERVER_XORG_SERVER_VERSION))
XSERVER_XORG_SERVER_SOURCE = xorg-server-$(XSERVER_XORG_SERVER_VERSION).tar.bz2
XSERVER_XORG_SERVER_SITE = http://xorg.freedesktop.org/releases/individual/xserver
XSERVER_XORG_SERVER_LICENSE = MIT
XSERVER_XORG_SERVER_LICENSE_FILES = COPYING
XSERVER_XORG_SERVER_INSTALL_STAGING = YES
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
	xproto_xf86vidmodeproto 	\
	xproto_xproto 			\
	xkeyboard-config		\
	pixman 				\
	mcookie 			\
	host-pkgconf

XSERVER_XORG_SERVER_CONF_OPTS = \
	--disable-config-hal \
	--disable-xnest \
	--disable-xephyr \
	--disable-dmx \
	--with-builder-addr=buildroot@buildroot.org \
	CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include/pixman-1" \
	--with-fontrootdir=/usr/share/fonts/X11/ \
	--$(if $(BR2_PACKAGE_XSERVER_XORG_SERVER_XVFB),en,dis)able-xvfb

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
XSERVER_XORG_SERVER_CONF_OPTS += \
	--with-systemd-daemon \
	--enable-systemd-logind
XSERVER_XORG_SERVER_DEPENDENCIES += systemd
else
XSERVER_XORG_SERVER_CONF_OPTS += \
	--without-systemd-daemon \
	--disable-systemd-logind
endif

# Present protocol only required for xserver 1.15+, but does not matter if
# enabled for older versions as they don't use it (not even optionally).
ifeq ($(BR2_PACKAGE_XPROTO_PRESENTPROTO),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xproto_presentproto
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_MODULAR),y)
XSERVER_XORG_SERVER_CONF_OPTS += --enable-xorg
XSERVER_XORG_SERVER_DEPENDENCIES += libpciaccess
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-xorg
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_KDRIVE),y)
XSERVER_XORG_SERVER_CONF_OPTS += \
	--enable-kdrive \
	--enable-xfbdev \
	--disable-glx \
	--disable-dri \
	--disable-xsdl
define XSERVER_CREATE_X_SYMLINK
	ln -f -s Xfbdev $(TARGET_DIR)/usr/bin/X
endef
XSERVER_XORG_SERVER_POST_INSTALL_TARGET_HOOKS += XSERVER_CREATE_X_SYMLINK

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_KDRIVE_EVDEV),y)
XSERVER_XORG_SERVER_CONF_OPTS += --enable-kdrive-evdev
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-kdrive-evdev
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_KDRIVE_KBD),y)
XSERVER_XORG_SERVER_CONF_OPTS += --enable-kdrive-kbd
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-kdrive-kbd
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_KDRIVE_MOUSE),y)
XSERVER_XORG_SERVER_CONF_OPTS += --enable-kdrive-mouse
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-kdrive-mouse
endif

else # modular
XSERVER_XORG_SERVER_CONF_OPTS += --disable-kdrive --disable-xfbdev
endif

ifeq ($(BR2_PACKAGE_MESA3D_DRI_DRIVER),y)
XSERVER_XORG_SERVER_CONF_OPTS += --enable-dri --enable-libdrm --enable-glx
XSERVER_XORG_SERVER_DEPENDENCIES += libdrm mesa3d xproto_xf86driproto
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-dri --disable-libdrm --disable-glx
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_AIGLX),y)
XSERVER_XORG_SERVER_CONF_OPTS += --enable-aiglx
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-aiglx
endif

# Optional packages
ifeq ($(BR2_PACKAGE_TSLIB),y)
XSERVER_XORG_SERVER_DEPENDENCIES += tslib
XSERVER_XORG_SERVER_CONF_OPTS += --enable-tslib LDFLAGS="-lts"
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
XSERVER_XORG_SERVER_DEPENDENCIES += udev
XSERVER_XORG_SERVER_CONF_OPTS += --enable-config-udev
# udev kms support depends on libdrm
ifeq ($(BR2_PACKAGE_LIBDRM),y)
XSERVER_XORG_SERVER_DEPENDENCIES += libdrm
XSERVER_XORG_SERVER_CONF_OPTS += --enable-config-udev-kms --enable-libdrm
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-config-udev-kms
endif
else
ifeq ($(BR2_PACKAGE_DBUS),y)
XSERVER_XORG_SERVER_DEPENDENCIES += dbus
XSERVER_XORG_SERVER_CONF_OPTS += --enable-config-dbus
endif
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
XSERVER_XORG_SERVER_DEPENDENCIES += freetype
endif

ifeq ($(BR2_PACKAGE_LIBUNWIND),y)
XSERVER_XORG_SERVER_DEPENDENCIES += libunwind
XSERVER_XORG_SERVER_CONF_OPTS += --enable-libunwind
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-libunwind
endif

ifeq ($(BR2_PACKAGE_XPROTO_RECORDPROTO),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xproto_recordproto
XSERVER_XORG_SERVER_CONF_OPTS += --enable-record
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-record
endif

ifneq ($(BR2_PACKAGE_XLIB_LIBXVMC),y)
XSERVER_XORG_SERVER_CONF_OPTS += --disable-xvmc
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCOMPOSITE),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xlib_libXcomposite
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-composite
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_MODULAR),y)
ifeq ($(BR2_PACKAGE_XPROTO_DRI2PROTO),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xproto_dri2proto
XSERVER_XORG_SERVER_CONF_OPTS += --enable-dri2
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-dri2
endif
ifeq ($(BR2_PACKAGE_XPROTO_DRI3PROTO),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xlib_libxshmfence xproto_dri3proto
XSERVER_XORG_SERVER_CONF_OPTS += --enable-dri3
ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_EGL),y)
XSERVER_XORG_SERVER_DEPENDENCIES += libepoxy
XSERVER_XORG_SERVER_CONF_OPTS += --enable-glamor
endif
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-dri3 --disable-glamor
endif
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-dri2 --disable-dri3 --disable-glamor
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXSCRNSAVER),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xlib_libXScrnSaver
XSERVER_XORG_SERVER_CONF_OPTS += --enable-screensaver
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-screensaver
endif

ifneq ($(BR2_PACKAGE_XLIB_LIBDMX),y)
XSERVER_XORG_SERVER_CONF_OPTS += --disable-dmx
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
XSERVER_XORG_SERVER_CONF_OPTS += --with-sha1=libcrypto
XSERVER_XORG_SERVER_DEPENDENCIES += openssl
else ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
XSERVER_XORG_SERVER_CONF_OPTS += --with-sha1=libgcrypt
XSERVER_XORG_SERVER_DEPENDENCIES += libgcrypt
else
XSERVER_XORG_SERVER_CONF_OPTS += --with-sha1=libsha1
XSERVER_XORG_SERVER_DEPENDENCIES += libsha1
endif

$(eval $(autotools-package))
