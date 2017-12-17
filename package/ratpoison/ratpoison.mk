################################################################################
#
# ratpoison
#
################################################################################

RATPOISON_VERSION = 1.4.9
RATPOISON_SOURCE = ratpoison-$(RATPOISON_VERSION).tar.xz
RATPOISON_SITE = http://download.savannah.nongnu.org/releases/ratpoison
RATPOISON_LICENSE = GPL-2.0+
RATPOISON_LICENSE_FILES = COPYING

RATPOISON_CONF_OPTS = \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib \
	--without-xkb \
	--without-xft

RATPOISON_DEPENDENCIES = xlib_libX11

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
RATPOISON_DEPENDENCIES += xlib_libXrandr
RATPOISON_CONF_OPTS += --with-xrandr
else
RATPOISON_CONF_OPTS += --without-xrandr
endif

$(eval $(autotools-package))
