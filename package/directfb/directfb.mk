#############################################################
#
# directfb
#
#############################################################
DIRECTFB_VERSION_MAJOR:=1.2
DIRECTFB_VERSION:=1.2.7
#DIRECTFB_VERSION:=1.3.0	is a development version
#DIRECTFB_VERSION_MAJOR:=1.3
DIRECTFB_SITE:=http://www.directfb.org/downloads/Core
DIRECTFB_SOURCE:=DirectFB-$(DIRECTFB_VERSION).tar.gz
DIRECTFB_AUTORECONF = NO
DIRECTFB_LIBTOOL_PATCH = NO
DIRECTFB_INSTALL_STAGING = YES
DIRECTFB_INSTALL_TARGET = YES

ifeq ($(BR2_PACKAGE_DIRECTFB_MULTI),y)
DIRECTFB_MULTI:=--enable-multi --enable-fusion
DIRECTFB_FUSION:=linux-fusion
else
DIRECTFB_MULTI:=
DIRECTFB_FUSION:=
endif
ifeq ($(BR2_PACKAGE_XSERVER),y)
DIRECTFB_X:=--enable-x11
else
DIRECTFB_X:=--disable-x11
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_UNIQUE),y)
DIRECTFB_UNIQUE:=--enable-unique
else
DIRECTFB_UNIQUE:=--disable-unique
endif

DIRECTFB_GFX:=
ifeq ($(BR2_PACKAGE_DIRECTFB_ATI128),y)
DIRECTFB_GFX+= ati128
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_CLE266),y)
DIRECTFB_GFX+= cle266
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_CYBER5K),y)
DIRECTFB_GFX+= cyber5k
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_MATROX),y)
DIRECTFB_GFX+= matrox
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_UNICHROME),y)
DIRECTFB_GFX+= unichrome
endif
ifeq ($(DIRECTFB_GFX),)
DIRECTFB_GFX:=none
else
DIRECTFB_GFX:=$(subst $(space),$(comma),$(strip $(DIRECTFB_GFX)))
endif

DIRECTFB_INPUT:=
ifeq ($(BR2_PACKAGE_DIRECTFB_KEYBOARD),y)
DIRECTFB_INPUT+= keyboard
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_PS2MOUSE),y)
DIRECTFB_INPUT+= ps2mouse
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_SERIALMOUSE),y)
DIRECTFB_INPUT+= serialmouse
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_TSLIB),y)
DIRECTFB_INPUT+= tslib
DIRECTFB_DEP+= tslib
endif
ifeq ($(DIRECTFB_INPUT),)
DIRECTFB_INPUT:=none
else
DIRECTFB_INPUT:=$(subst $(space),$(comma),$(strip $(DIRECTFB_INPUT)))
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_GIF),y)
DIRECTFB_GIF:=--enable-gif
DIRECTFB_DEP+= libungif
else
DIRECTFB_GIF:=--disable-gif
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_PNG),y)
DIRECTFB_PNG:=--enable-png
DIRECTFB_DEP+= libpng
else
DIRECTFB_PNG:=--disable-png
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_JPEG),y)
DIRECTFB_JPEG:=--enable-jpeg
DIRECTFB_DEP+= jpeg
else
DIRECTFB_JPEG:=--disable-jpeg
endif

DIRECTFB_CONF_OPT = \
	--localstatedir=/var \
	--with-gfxdrivers=$(DIRECTFB_GFX) \
	--with-inputdrivers=$(DIRECTFB_INPUT) \
	--enable-static \
	--enable-shared \
	--disable-explicit-deps \
	$(DIRECTFB_MULTI) \
	$(DIRECTFB_X) \
	$(DIRECTFB_JPEG) \
	$(DIRECTFB_PNG) \
	$(DIRECTFB_GIF) \
	$(DIRECTFB_UNIQUE) \
	--enable-linux-input \
	--enable-zlib \
	--enable-freetype \
	--enable-fbdev \
	--disable-sysfs \
	--disable-sdl \
	--disable-vnc \
	--disable-video4linux \
	--disable-video4linux2

DIRECTFB_DEPENDENCIES = uclibc $(DIRECTFB_DEP) freetype $(DIRECTFB_FUSION)

$(eval $(call AUTOTARGETS,package,directfb))
