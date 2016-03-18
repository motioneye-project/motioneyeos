################################################################################
#
# tekui
#
################################################################################

TEKUI_VERSION = 1.12
TEKUI_SOURCE = tekui-$(TEKUI_VERSION).tgz
TEKUI_SITE = http://tekui.neoscientists.org/releases
TEKUI_LICENSE = MIT
TEKUI_LICENSE_FILES = COPYRIGHT
TEKUI_DEPENDENCIES = freetype luainterpreter

TEKUI_MAKE_OPTS = \
	CC="$(TARGET_CC) -fPIC" \
	AR="$(TARGET_AR) rcu" \
	INSTALL_S="install" \
	LUAVER=$(LUAINTERPRETER_ABIVER) \
	LUA_DEFS=""

ifeq ($(BR2_PACKAGE_LIBPNG),y)
TEKUI_DEPENDENCIES += libpng
TEKUI_MAKE_OPTS += TEKUI_DEFS="-DENABLE_GRADIENT -DENABLE_FILENO -DENABLE_PIXMAP_CACHE -DENABLE_PNG"
TEKUI_MAKE_OPTS += TEKUI_LIBS=-lpng
else
TEKUI_MAKE_OPTS += TEKUI_DEFS="-DENABLE_GRADIENT -DENABLE_FILENO -DENABLE_PIXMAP_CACHE"
endif

ifeq ($(BR2_PACKAGE_DEJAVU),y)
TEKUI_FONTDIR=/usr/share/fonts/dejavu
else
TEKUI_FONTDIR=/usr/share/lua/$(LUAINTERPRETER_ABIVER)/tek/ui/font
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFT)$(BR2_PACKAGE_XLIB_LIBXXF86VM),yy)
TEKUI_DEPENDENCIES += xlib_libXft xlib_libXxf86vm
TEKUI_MAKE_OPTS += \
	X11_LIBS="-lXext -lXxf86vm -lXft -lfreetype -lfontconfig" \
	X11_DEFS="-D_XOPEN_SOURCE -DENABLE_XFT -DENABLE_XVID -I$(STAGING_DIR)/usr/include/freetype2 -I$(STAGING_DIR)/usr/include/fontconfig" \
	DISPLAY_DRIVER=x11
else
ifeq ($(BR2_PACKAGE_DIRECTFB),y)
TEKUI_DEPENDENCIES += directfb
TEKUI_MAKE_OPTS += \
	DIRECTFB_LIBS="-lfreetype -ldirectfb -lpthread" \
	DIRECTFB_DEFS="-D_REENTRANT -I$(STAGING_DIR)/usr/include/directfb -I$(STAGING_DIR)/usr/include/freetype2" \
	DISPLAY_DRIVER=directfb
else
TEKUI_MAKE_OPTS += \
	FREETYPE_LIBS=-lfreetype \
	FREETYPE_DEFS="-I$(STAGING_DIR)/usr/include/freetype2" \
	RAWFB_SUB_LIBS="" \
	RAWFB_SUB_DEFS="-DDEF_FONTDIR=\\\"$(TEKUI_FONTDIR)\\\"" \
	DISPLAY_DRIVER=rawfb
endif
endif

define TEKUI_BUILD_CMDS
	$(MAKE) $(TEKUI_MAKE_OPTS) PREFIX="/usr" -C $(@D) all
endef

define TEKUI_INSTALL_TARGET_CMDS
	$(MAKE) $(TEKUI_MAKE_OPTS) PREFIX="$(TARGET_DIR)/usr" -C $(@D) install
endef

$(eval $(generic-package))
