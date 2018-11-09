################################################################################
#
# xterm
#
################################################################################

XTERM_VERSION = 327
XTERM_SOURCE = xterm-$(XTERM_VERSION).tgz
XTERM_SITE = http://invisible-mirror.net/archives/xterm
XTERM_DEPENDENCIES = ncurses xlib_libXaw host-pkgconf
XTERM_LICENSE = MIT
XTERM_LICENSE_FILES = version.c
XTERM_CONF_OPTS = --enable-256-color \
	--x-includes=$(STAGING_DIR)/usr/include \
	--x-libraries=$(STAGING_DIR)/usr/lib

# Avoid freetype2 path poisoning by imake
XTERM_CONF_ENV = ac_cv_path_IMAKE=""

ifeq ($(BR2_PACKAGE_XLIB_LIBXFT),y)
XTERM_DEPENDENCIES += xlib_libXft
XTERM_CONF_OPTS += --enable-freetype \
	--with-freetype-config=auto
else
XTERM_CONF_OPTS += --disable-freetype
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
XTERM_DEPENDENCIES += xlib_libXinerama
XTERM_CONF_OPTS += --with-xinerama
else
XTERM_CONF_OPTS += --without-xinerama
endif

$(eval $(autotools-package))
