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
MATCHBOX_CONF_OPTS = --enable-expat --disable-gconf

# Workaround bug in configure script
MATCHBOX_CONF_ENV = expat=yes

ifeq ($(BR2_PACKAGE_X11R7_LIBXCOMPOSITE),y)
ifeq ($(BR2_PACKAGE_X11R7_LIBXPM),y)
MATCHBOX_CONF_OPTS += --enable-composite
MATCHBOX_DEPENDENCIES += xlib_libXcomposite
MATCHBOX_DEPENDENCIES += xlib_libXpm
endif
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFT),y)
MATCHBOX_DEPENDENCIES += xlib_libXft
endif

ifeq ($(BR2_PACKAGE_STARTUP_NOTIFICATION),y)
MATCHBOX_CONF_OPTS += --enable-startup-notification
MATCHBOX_DEPENDENCIES += startup-notification
else
MATCHBOX_CONF_OPTS += --disable-startup-notification
endif

$(eval $(autotools-package))
