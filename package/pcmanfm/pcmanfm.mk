################################################################################
#
# pcmanfm
#
################################################################################

PCMANFM_VERSION = 1.2.4
PCMANFM_SOURCE = pcmanfm-$(PCMANFM_VERSION).tar.xz
PCMANFM_SITE = http://sourceforge.net/projects/pcmanfm/files
PCMANFM_DEPENDENCIES = libglib2 menu-cache libfm
PCMANFM_LICENSE = GPLv2+
PCMANFM_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBGTK3_X11),y)
PCMANFM_CONF_OPTS += --with-gtk=3
PCMANFM_DEPENDENCIES += libgtk3
else
PCMANFM_CONF_OPTS += --with-gtk=2
PCMANFM_DEPENDENCIES += libgtk2
endif

$(eval $(autotools-package))
