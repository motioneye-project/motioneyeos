################################################################################
#
# pcmanfm
#
################################################################################

PCMANFM_VERSION = 1.3.1
PCMANFM_SOURCE = pcmanfm-$(PCMANFM_VERSION).tar.xz
PCMANFM_SITE = http://sourceforge.net/projects/pcmanfm/files
PCMANFM_DEPENDENCIES = libglib2 menu-cache libfm $(TARGET_NLS_DEPENDENCIES)
PCMANFM_LICENSE = GPL-2.0+
PCMANFM_LICENSE_FILES = COPYING
PCMANFM_CONF_ENV = LIBS=$(TARGET_NLS_LIBS)

ifeq ($(BR2_PACKAGE_LIBGTK3_X11),y)
PCMANFM_CONF_OPTS += --with-gtk=3
PCMANFM_DEPENDENCIES += libgtk3
else
PCMANFM_CONF_OPTS += --with-gtk=2
PCMANFM_DEPENDENCIES += libgtk2
endif

$(eval $(autotools-package))
