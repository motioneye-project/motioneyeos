################################################################################
#
# fluxbox
#
################################################################################

FLUXBOX_VERSION = 1.3.7
FLUXBOX_SOURCE = fluxbox-$(FLUXBOX_VERSION).tar.xz
FLUXBOX_SITE = http://downloads.sourceforge.net/project/fluxbox/fluxbox/$(FLUXBOX_VERSION)
FLUXBOX_LICENSE = MIT
FLUXBOX_LICENSE_FILES = COPYING

FLUXBOX_CONF_OPTS = \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib
FLUXBOX_DEPENDENCIES = xlib_libX11 $(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifeq ($(BR2_PACKAGE_FREETYPE),y)
FLUXBOX_CONF_OPTS += --enable-freetype2
FLUXBOX_DEPENDENCIES += freetype
else
FLUXBOX_CONF_OPTS += --disable-freetype2
endif

ifeq ($(BR2_PACKAGE_IMLIB2_X),y)
FLUXBOX_CONF_OPTS += --enable-imlib2
FLUXBOX_DEPENDENCIES += imlib2
else
FLUXBOX_CONF_OPTS += --disable-imlib2
endif

ifeq ($(BR2_PACKAGE_LIBFRIBIDI),y)
FLUXBOX_CONF_OPTS += --enable-fribidi
FLUXBOX_DEPENDENCIES += libfribidi
else
FLUXBOX_CONF_OPTS += --disable-fribidi
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFT),y)
FLUXBOX_CONF_OPTS += --enable-xft
FLUXBOX_DEPENDENCIES += xlib_libXft
else
FLUXBOX_CONF_OPTS += --disable-xft
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRENDER),y)
FLUXBOX_CONF_OPTS += --enable-xrender
FLUXBOX_DEPENDENCIES += xlib_libXrender
else
FLUXBOX_CONF_OPTS += --disable-xrender
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXPM),y)
FLUXBOX_CONF_OPTS += --enable-xpm
FLUXBOX_DEPENDENCIES += xlib_libXpm
else
FLUXBOX_CONF_OPTS += --disable-xpm
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
FLUXBOX_CONF_OPTS += --enable-xinerama
FLUXBOX_DEPENDENCIES += xlib_libXinerama
else
FLUXBOX_CONF_OPTS += --disable-xinerama
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXEXT),y)
FLUXBOX_CONF_OPTS += --enable-xext
FLUXBOX_DEPENDENCIES += xlib_libXext
else
FLUXBOX_CONF_OPTS += --disable-xext
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
FLUXBOX_CONF_OPTS += --enable-xrandr
FLUXBOX_DEPENDENCIES += xlib_libXrandr
else
FLUXBOX_CONF_OPTS += --disable-xrandr
endif

define FLUXBOX_INSTALL_XSESSION_FILE
	$(INSTALL) -m 0755 -D package/fluxbox/xsession \
		$(TARGET_DIR)/root/.xsession
endef

FLUXBOX_POST_INSTALL_TARGET_HOOKS += FLUXBOX_INSTALL_XSESSION_FILE

$(eval $(autotools-package))
