################################################################################
#
# matchbox-desktop
#
################################################################################

MATCHBOX_DESKTOP_VERSION_MAJOR = 0.9
MATCHBOX_DESKTOP_VERSION = $(MATCHBOX_DESKTOP_VERSION_MAJOR).1
MATCHBOX_DESKTOP_SOURCE = matchbox-desktop-$(MATCHBOX_DESKTOP_VERSION).tar.bz2
MATCHBOX_DESKTOP_SITE = http://downloads.yoctoproject.org/releases/matchbox/matchbox-desktop/$(MATCHBOX_DESKTOP_VERSION_MAJOR)
MATCHBOX_DESKTOP_LICENSE = GPLv2+
MATCHBOX_DESKTOP_LICENSE_FILES = COPYING
MATCHBOX_DESKTOP_DEPENDENCIES = matchbox-lib zlib
MATCHBOX_DESKTOP_CONF_OPTS = --enable-expat

# The bundled configure script does not properly replace LIBADD_DL, so
# we force an autoreconf even if we don't have any patches touching
# configure.ac/Makefile.am.
MATCHBOX_DESKTOP_AUTORECONF = YES

################################################################################

ifeq ($(BR2_PACKAGE_STARTUP_NOTIFICATION),y)
MATCHBOX_DESKTOP_CONF_OPTS += --enable-startup-notification
MATCHBOX_DESKTOP_DEPENDENCIES += startup-notification
else
MATCHBOX_DESKTOP_CONF_OPTS += --disable-startup-notification
endif

################################################################################

$(eval $(autotools-package))
