################################################################################
#
# openbox
#
################################################################################

OPENBOX_VERSION = 3.6.1
OPENBOX_SOURCE = openbox-$(OPENBOX_VERSION).tar.xz
OPENBOX_SITE = http://openbox.org/dist/openbox
OPENBOX_LICENSE = GPLv2+
OPENBOX_LICENSE_FILES = COPYING

OPENBOX_CONF_OPTS = \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib

OPENBOX_DEPENDENCIES = xlib_libX11 libxml2 libglib2 pango host-pkgconf

ifeq ($(BR2_PACKAGE_IMLIB2_X),y)
OPENBOX_CONF_OPTS += --enable-imlib2
OPENBOX_DEPENDENCIES += imlib2
else
OPENBOX_CONF_OPTS += --disable-imlib2
endif

ifeq ($(BR2_PACKAGE_STARTUP_NOTIFICATION),y)
OPENBOX_CONF_OPTS += --enable-startup-notification
OPENBOX_DEPENDENCIES += startup-notification
else
OPENBOX_CONF_OPTS += --disable-startup-notification
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBSM),y)
OPENBOX_CONF_OPTS += --enable-session-management
OPENBOX_DEPENDENCIES += xlib_libSM
else
OPENBOX_CONF_OPTS += --disable-session-management
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
OPENBOX_CONF_OPTS += --enable-xinerama
OPENBOX_DEPENDENCIES += xlib_libXinerama
else
OPENBOX_CONF_OPTS += --disable-xinerama
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
OPENBOX_CONF_OPTS += --enable-xrandr
OPENBOX_DEPENDENCIES += xlib_libXrandr
else
OPENBOX_CONF_OPTS += --disable-xrandr
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCURSOR),y)
OPENBOX_DEPENDENCIES += xlib_libXcursor
OPENBOX_CONF_OPTS += --enable-xcursor
else
OPENBOX_CONF_OPTS += --disable-xcursor
endif

$(eval $(autotools-package))
