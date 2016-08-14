################################################################################
#
# xterm
#
################################################################################

XTERM_VERSION = 324
XTERM_SOURCE = xterm-$(XTERM_VERSION).tgz
XTERM_SITE = http://invisible-mirror.net/archives/xterm
XTERM_DEPENDENCIES = ncurses xlib_libXaw host-pkgconf
XTERM_LICENSE = MIT
XTERM_LICENSE_FILES = version.c
XTERM_CONF_OPTS = --enable-256-color \
	--x-includes=$(STAGING_DIR)/usr/include \
	--x-libraries=$(STAGING_DIR)/usr/lib

ifeq ($(BR2_PACKAGE_XLIB_LIBXFT),y)
XTERM_DEPENDENCIES += xlib_libXft
XTERM_CONF_OPTS += --enable-freetype \
	--with-freetype-config=auto
else
XTERM_CONF_OPTS += --disable-freetype
endif

$(eval $(autotools-package))
