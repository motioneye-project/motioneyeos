#############################################################
#
# SDL
#
#############################################################
SDL_VERSION:=1.2.14
SDL_SOURCE:=SDL-$(SDL_VERSION).tar.gz
SDL_SITE:=http://www.libsdl.org/release

SDL_LIBTOOL_PATCH = NO
SDL_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_SDL_FBCON),y)
SDL_CONF_OPT+=--enable-video-fbcon=yes
else
SDL_CONF_OPT+=--enable-video-fbcon=no
endif

ifeq ($(BR2_PACKAGE_SDL_DIRECTFB),y)
SDL_DEPENDENCIES += directfb
SDL_CONF_OPT+=--enable-video-directfb=yes
else
SDL_CONF_OPT=--enable-video-directfb=no
endif

ifeq ($(BR2_PACKAGE_SDL_QTOPIA),y)
SDL_CONF_OPT+=--enable-video-qtopia=yes
SDL_DEPENDENCIES += qt
else
SDL_CONF_OPT+=--enable-video-qtopia=no
endif

ifeq ($(BR2_PACKAGE_SDL_X11),y)
SDL_CONF_OPT+=--enable-video-x11=yes
SDL_DEPENDENCIES += xserver_xorg-server
else
SDL_CONF_OPT+=--enable-video-x11=no
endif

ifeq ($(BR2_PACKAGE_TSLIB),y)
SDL_DEPENDENCIES += tslib
endif

SDL_CONF_OPT += --enable-pulseaudio=no \
		--disable-arts \
		--disable-esd \
		--disable-nasm

define SDL_POST_INSTALL_STAGING_HOOKS
       $(SED) 's^libdir=\$${exec_prefix}^libdir=/usr^' \
               $(STAGING_DIR)/usr/bin/sdl-config
endef

define SDL_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libSDL*.so* $(TARGET_DIR)/usr/lib/
endef

$(eval $(call AUTOTARGETS,package,sdl))
