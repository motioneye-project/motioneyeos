################################################################################
#
# sdl
#
################################################################################

SDL_VERSION = 1.2.15
SDL_SOURCE = SDL-$(SDL_VERSION).tar.gz
SDL_SITE = http://www.libsdl.org/release
SDL_LICENSE = LGPLv2.1+
SDL_LICENSE_FILES = COPYING
SDL_INSTALL_STAGING = YES

# we're patching configure.in, but package cannot autoreconf with our version of
# autotools, so we have to do it manually instead of setting SDL_AUTORECONF = YES
define SDL_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) ./autogen.sh
endef

SDL_PRE_CONFIGURE_HOOKS += SDL_RUN_AUTOGEN
HOST_SDL_PRE_CONFIGURE_HOOKS += SDL_RUN_AUTOGEN

SDL_DEPENDENCIES += host-automake host-autoconf host-libtool
HOST_SDL_DEPENDENCIES += host-automake host-autoconf host-libtool

ifeq ($(BR2_PACKAGE_SDL_FBCON),y)
SDL_CONF_OPTS += --enable-video-fbcon=yes
else
SDL_CONF_OPTS += --enable-video-fbcon=no
endif

ifeq ($(BR2_PACKAGE_SDL_DIRECTFB),y)
SDL_DEPENDENCIES += directfb
SDL_CONF_OPTS += --enable-video-directfb=yes
SDL_CONF_ENV = ac_cv_path_DIRECTFBCONFIG=$(STAGING_DIR)/usr/bin/directfb-config
else
SDL_CONF_OPTS += --enable-video-directfb=no
endif

ifeq ($(BR2_PACKAGE_SDL_QTOPIA),y)
SDL_CONF_OPTS += --enable-video-qtopia=yes
SDL_DEPENDENCIES += qt
else
SDL_CONF_OPTS += --enable-video-qtopia=no
endif

ifeq ($(BR2_PACKAGE_SDL_X11),y)
SDL_CONF_OPTS += --enable-video-x11=yes
SDL_DEPENDENCIES += \
	xlib_libX11 xlib_libXext \
	$(if $(BR2_PACKAGE_XLIB_LIBXRENDER), xlib_libXrender) \
	$(if $(BR2_PACKAGE_XLIB_LIBXRANDR), xlib_libXrandr)
else
SDL_CONF_OPTS += --enable-video-x11=no
endif

ifneq ($(BR2_USE_MMU),y)
SDL_CONF_OPTS += --enable-dga=no
endif

# overwrite autodection (prevents confusion with host libpth version)
ifeq ($(BR2_PACKAGE_LIBPTHSEM_COMPAT),y)
SDL_CONF_OPTS += --enable-pth
SDL_CONF_ENV += ac_cv_path_PTH_CONFIG=$(STAGING_DIR)/usr/bin/pth-config
SDL_DEPENDENCIES += libpthsem
else
SDL_CONF_OPTS += --disable-pth
endif

ifeq ($(BR2_PACKAGE_TSLIB),y)
SDL_DEPENDENCIES += tslib
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
SDL_DEPENDENCIES += alsa-lib
endif

ifeq ($(BR2_PACKAGE_MESA3D),y)
SDL_DEPENDENCIES += mesa3d
endif

SDL_CONF_OPTS += \
	--enable-pulseaudio=no \
	--disable-arts \
	--disable-esd \
	--disable-nasm \
	--disable-video-ps3

HOST_SDL_CONF_OPTS += \
	--enable-pulseaudio=no \
	--enable-video-x11=no \
	--disable-arts \
	--disable-esd \
	--disable-nasm \
	--disable-video-ps3

SDL_CONFIG_SCRIPTS = sdl-config

# Remove the -Wl,-rpath option.
define SDL_FIXUP_SDL_CONFIG
	$(SED) 's%-Wl,-rpath,\$${libdir}%%' \
		$(STAGING_DIR)/usr/bin/sdl-config
endef

SDL_POST_INSTALL_STAGING_HOOKS += SDL_FIXUP_SDL_CONFIG

$(eval $(autotools-package))
$(eval $(host-autotools-package))
