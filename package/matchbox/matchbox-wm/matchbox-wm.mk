################################################################################
#
# matchbox-wm
#
################################################################################

MATCHBOX_WM_VERSION = 1.2
MATCHBOX_WM_SOURCE = matchbox-window-manager-$(MATCHBOX_WM_VERSION).tar.bz2
MATCHBOX_WM_SITE = http://downloads.yoctoproject.org/releases/matchbox/matchbox-window-manager/$(MATCHBOX_WM_VERSION)
MATCHBOX_WM_LICENSE = GPLv2+
MATCHBOX_WM_LICENSE_FILES = COPYING

MATCHBOX_WM_DEPENDENCIES = matchbox-lib
MATCHBOX_WM_CONF_OPTS = --enable-expat

# Workaround bug in configure script
MATCHBOX_WM_CONF_ENV = expat=yes

ifeq ($(BR2_PACKAGE_X11R7_LIBXCOMPOSITE),y)
ifeq ($(BR2_PACKAGE_X11R7_LIBXPM),y)
MATCHBOX_WM_CONF_OPTS += --enable-composite
MATCHBOX_WM_DEPENDENCIES += xlib_libXcomposite
MATCHBOX_WM_DEPENDENCIES += xlib_libXpm
endif
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFT),y)
#MATCHBOX_WM_OPTS += --enable-standalone-xft
MATCHBOX_WM_DEPENDENCIES += xlib_libXft
else
#MATCHBOX_WM_OPTS += --disable-standalone-xft
endif

ifeq ($(BR2_PACKAGE_STARTUP_NOTIFICATION),y)
MATCHBOX_WM_CONF_OPTS += --enable-startup-notification
MATCHBOX_WM_DEPENDENCIES += startup-notification
else
MATCHBOX_WM_CONF_OPTS += --disable-startup-notification
endif

$(eval $(autotools-package))
