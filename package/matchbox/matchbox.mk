################################################################################
#
# matchbox
#
################################################################################

MATCHBOX_VERSION = 1.2
MATCHBOX_SOURCE = matchbox-window-manager-$(MATCHBOX_VERSION).tar.bz2
MATCHBOX_SITE = http://downloads.yoctoproject.org/releases/matchbox/matchbox-window-manager/$(MATCHBOX_VERSION)
MATCHBOX_LICENSE = GPLv2+
MATCHBOX_LICENSE_FILES = COPYING

MATCHBOX_DEPENDENCIES = matchbox-lib
MATCHBOX_CONF_OPTS = \
	--enable-expat \
	--disable-gconf \
	--disable-composite \
	--disable-standalone \
	--disable-standalone-xft

# Workaround bug in configure script
MATCHBOX_CONF_ENV = expat=yes

ifeq ($(BR2_PACKAGE_STARTUP_NOTIFICATION),y)
MATCHBOX_CONF_OPTS += --enable-startup-notification
MATCHBOX_DEPENDENCIES += startup-notification
else
MATCHBOX_CONF_OPTS += --disable-startup-notification
endif

ifeq ($(BR2_PACKAGE_MATCHBOX_SM),y)
MATCHBOX_CONF_OPTS += --enable-session
MATCHBOX_DEPENDENCIES += xlib_libSM
else
MATCHBOX_CONF_OPTS += --disable-session
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCURSOR),y)
MATCHBOX_DEPENDENCIES += xlib_libXcursor
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFIXES),y)
MATCHBOX_DEPENDENCIES += xlib_libXfixes
endif

$(eval $(autotools-package))
