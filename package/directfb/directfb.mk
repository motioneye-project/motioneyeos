################################################################################
#
# directfb
#
################################################################################

DIRECTFB_VERSION_MAJOR = 1.7
DIRECTFB_VERSION = $(DIRECTFB_VERSION_MAJOR).7
DIRECTFB_SITE = http://www.directfb.org/downloads/Core/DirectFB-$(DIRECTFB_VERSION_MAJOR)
DIRECTFB_SOURCE = DirectFB-$(DIRECTFB_VERSION).tar.gz
DIRECTFB_LICENSE = LGPLv2.1+
DIRECTFB_LICENSE_FILES = COPYING
DIRECTFB_INSTALL_STAGING = YES
DIRECTFB_AUTORECONF = YES

DIRECTFB_CONF_OPTS = \
	--enable-zlib \
	--enable-freetype \
	--enable-fbdev \
	--disable-sdl \
	--disable-vnc \
	--disable-osx \
	--disable-video4linux \
	--disable-video4linux2 \
	--without-tools \
	--disable-x11

ifeq ($(BR2_STATIC_LIBS),y)
DIRECTFB_CONF_OPTS += --disable-dynload
endif

DIRECTFB_CONFIG_SCRIPTS = directfb-config

DIRECTFB_DEPENDENCIES = freetype zlib

ifeq ($(BR2_PACKAGE_DIRECTFB_MULTI),y)
DIRECTFB_CONF_OPTS += --enable-multi --enable-multi-kernel
DIRECTFB_DEPENDENCIES += linux-fusion
else
DIRECTFB_CONF_OPTS += --disable-multi --disable-multi-kernel
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_DEBUG_SUPPORT),y)
DIRECTFB_CONF_OPTS += --enable-debug-support
ifeq ($(BR2_PACKAGE_DIRECTFB_DEBUG),y)
DIRECTFB_CONF_OPTS += --enable-debug
endif
else
DIRECTFB_CONF_OPTS += --disable-debug-support
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_TRACE),y)
DIRECTFB_CONF_OPTS += --enable-trace
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_DIVINE),y)
DIRECTFB_CONF_OPTS += --enable-divine
else
DIRECTFB_CONF_OPTS += --disable-divine
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_SAWMAN),y)
DIRECTFB_CONF_OPTS += --enable-sawman
else
DIRECTFB_CONF_OPTS += --disable-sawman
endif

DIRECTFB_GFX = \
	$(if $(BR2_PACKAGE_DIRECTFB_ATI128),ati128) \
	$(if $(BR2_PACKAGE_DIRECTFB_CYBER5K),cyber5k) \
	$(if $(BR2_PACKAGE_DIRECTFB_MATROX),matrox) \
	$(if $(BR2_PACKAGE_DIRECTFB_PXA3XX),pxa3xx) \
	$(if $(BR2_PACKAGE_DIRECTFB_I830),i830)	\
	$(if $(BR2_PACKAGE_DIRECTFB_EP9X),ep9x)

ifeq ($(strip $(DIRECTFB_GFX)),)
DIRECTFB_CONF_OPTS += --with-gfxdrivers=none
else
DIRECTFB_CONF_OPTS += \
	--with-gfxdrivers=$(subst $(space),$(comma),$(strip $(DIRECTFB_GFX)))
endif

DIRECTFB_INPUT = \
	$(if $(BR2_PACKAGE_DIRECTFB_LINUXINPUT),linuxinput) \
	$(if $(BR2_PACKAGE_DIRECTFB_KEYBOARD),keyboard) \
	$(if $(BR2_PACKAGE_DIRECTFB_PS2MOUSE),ps2mouse) \
	$(if $(BR2_PACKAGE_DIRECTFB_SERIALMOUSE),serialmouse) \
	$(if $(BR2_PACKAGE_DIRECTFB_TSLIB),tslib)

ifeq ($(BR2_PACKAGE_DIRECTFB_TSLIB),y)
DIRECTFB_DEPENDENCIES += tslib
endif

ifeq ($(strip $(DIRECTFB_INPUT)),)
DIRECTFB_CONF_OPTS += --with-inputdrivers=none
else
DIRECTFB_CONF_OPTS += \
	--with-inputdrivers=$(subst $(space),$(comma),$(strip $(DIRECTFB_INPUT)))
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_GIF),y)
DIRECTFB_CONF_OPTS += --enable-gif
else
DIRECTFB_CONF_OPTS += --disable-gif
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_TIFF),y)
DIRECTFB_CONF_OPTS += --enable-tiff
DIRECTFB_DEPENDENCIES += tiff
else
DIRECTFB_CONF_OPTS += --disable-tiff
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_PNG),y)
DIRECTFB_CONF_OPTS += --enable-png
DIRECTFB_DEPENDENCIES += libpng
DIRECTFB_CONF_ENV += ac_cv_path_LIBPNG_CONFIG=$(STAGING_DIR)/usr/bin/libpng-config
else
DIRECTFB_CONF_OPTS += --disable-png
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_JPEG),y)
DIRECTFB_CONF_OPTS += --enable-jpeg
DIRECTFB_DEPENDENCIES += jpeg
else
DIRECTFB_CONF_OPTS += --disable-jpeg
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_SVG),y)
DIRECTFB_CONF_OPTS += --enable-svg
# needs some help to find cairo includes
DIRECTFB_CONF_ENV += CPPFLAGS="$(TARGET_CPPFLAGS) -I$(STAGING_DIR)/usr/include/cairo"
DIRECTFB_DEPENDENCIES += libsvg-cairo
else
DIRECTFB_CONF_OPTS += --disable-svg
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_IMLIB2),y)
DIRECTFB_CONF_OPTS += --enable-imlib2
DIRECTFB_DEPENDENCIES += imlib2
DIRECTFB_CONF_ENV += ac_cv_path_IMLIB2_CONFIG=$(STAGING_DIR)/usr/bin/imlib2-config
else
DIRECTFB_CONF_OPTS += --disable-imlib2
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_DITHER_RGB16),y)
DIRECTFB_CONF_OPTS += --with-dither-rgb16=advanced
else
DIRECTFB_CONF_OPTS += --with-dither-rgb16=none
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_TESTS),y)
DIRECTFB_CONF_OPTS += --with-tests
endif

HOST_DIRECTFB_DEPENDENCIES = host-pkgconf host-libpng
HOST_DIRECTFB_CONF_OPTS = \
	--disable-multi \
	--enable-png \
	--with-gfxdrivers=none \
	--with-inputdrivers=none

HOST_DIRECTFB_BUILD_CMDS = \
	$(MAKE) -C $(@D)/tools directfb-csource

HOST_DIRECTFB_INSTALL_CMDS = \
	$(INSTALL) -m 0755 $(@D)/tools/directfb-csource $(HOST_DIR)/usr/bin

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# directfb-csource for the host
DIRECTFB_HOST_BINARY = $(HOST_DIR)/usr/bin/directfb-csource
