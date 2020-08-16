################################################################################
#
# glslsandbox-player
#
################################################################################

GLSLSANDBOX_PLAYER_VERSION = 2019.08.23
GLSLSANDBOX_PLAYER_SITE = $(call github,jolivain,glslsandbox-player,v$(GLSLSANDBOX_PLAYER_VERSION))
GLSLSANDBOX_PLAYER_AUTORECONF = YES
GLSLSANDBOX_PLAYER_DEPENDENCIES = libegl libgles host-pkgconf

GLSLSANDBOX_PLAYER_LICENSE = BSD-2-Clause
GLSLSANDBOX_PLAYER_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_GLSLSANDBOX_PLAYER_PNG),y)
GLSLSANDBOX_PLAYER_DEPENDENCIES += libpng
GLSLSANDBOX_PLAYER_CONF_OPTS += --with-libpng
else
GLSLSANDBOX_PLAYER_CONF_OPTS += --without-libpng
endif

ifeq ($(BR2_PACKAGE_GLSLSANDBOX_PLAYER_TESTING),y)
GLSLSANDBOX_PLAYER_CONF_OPTS += \
	--with-shader-list=shader-tests.list \
	--enable-testing \
	--enable-install-testsuite
else
GLSLSANDBOX_PLAYER_CONF_OPTS += \
	--with-shader-list=shader-local.list \
	--disable-testing
endif

ifeq ($(BR2_PACKAGE_GLSLSANDBOX_PLAYER_SCRIPTS),y)
GLSLSANDBOX_PLAYER_CONF_OPTS += --enable-install-scripts
else
GLSLSANDBOX_PLAYER_CONF_OPTS += --disable-install-scripts
endif

ifeq ($(BR2_PACKAGE_GLSLSANDBOX_PLAYER_KMS),y)
# gbm dependency is not needed, as it is normally packaged with
# libegl/libgles drivers.
GLSLSANDBOX_PLAYER_DEPENDENCIES += libdrm
GLSLSANDBOX_PLAYER_CONF_OPTS += --with-native-gfx=kms
else ifeq ($(BR2_PACKAGE_GLSLSANDBOX_PLAYER_MALI),y)
GLSLSANDBOX_PLAYER_DEPENDENCIES += sunxi-mali-mainline
GLSLSANDBOX_PLAYER_CONF_OPTS += --with-native-gfx=mali
else ifeq ($(BR2_PACKAGE_GLSLSANDBOX_PLAYER_RPI),y)
GLSLSANDBOX_PLAYER_DEPENDENCIES += rpi-userland
GLSLSANDBOX_PLAYER_CONF_OPTS += --with-native-gfx=rpi
else ifeq ($(BR2_PACKAGE_GLSLSANDBOX_PLAYER_SDL2),y)
GLSLSANDBOX_PLAYER_DEPENDENCIES += sdl2
GLSLSANDBOX_PLAYER_CONF_OPTS += --with-native-gfx=sdl2
else ifeq ($(BR2_PACKAGE_GLSLSANDBOX_PLAYER_TISGX),y)
GLSLSANDBOX_PLAYER_DEPENDENCIES += ti-sgx-um
GLSLSANDBOX_PLAYER_CONF_OPTS += --with-native-gfx=tisgx
else ifeq ($(BR2_PACKAGE_GLSLSANDBOX_PLAYER_VIVFB),y)
GLSLSANDBOX_PLAYER_DEPENDENCIES += imx-gpu-viv
GLSLSANDBOX_PLAYER_CONF_OPTS += --with-native-gfx=vivfb
else ifeq ($(BR2_PACKAGE_GLSLSANDBOX_PLAYER_WL),y)
GLSLSANDBOX_PLAYER_DEPENDENCIES += wayland
GLSLSANDBOX_PLAYER_CONF_OPTS += --with-native-gfx=wl
ifeq ($(BR2_PACKAGE_GLSLSANDBOX_PLAYER_WL_IVI),y)
GLSLSANDBOX_PLAYER_CONF_OPTS += --enable-ivi
else
GLSLSANDBOX_PLAYER_CONF_OPTS += --disable-ivi
endif
else ifeq ($(BR2_PACKAGE_GLSLSANDBOX_PLAYER_X11),y)
GLSLSANDBOX_PLAYER_DEPENDENCIES += xlib_libX11
GLSLSANDBOX_PLAYER_CONF_OPTS += --with-native-gfx=x11
endif

$(eval $(autotools-package))
