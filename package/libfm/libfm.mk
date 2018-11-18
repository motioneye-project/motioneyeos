################################################################################
#
# libfm
#
################################################################################

LIBFM_VERSION = 1.3.0.2
LIBFM_SOURCE = libfm-$(LIBFM_VERSION).tar.xz
LIBFM_SITE = http://sourceforge.net/projects/pcmanfm/files
LIBFM_DEPENDENCIES = menu-cache libglib2 cairo
LIBFM_LICENSE = GPL-2.0+, LGPL-2.1+
LIBFM_LICENSE_FILES = COPYING src/extra/fm-xml-file.c
LIBFM_INSTALL_STAGING = YES
# We're patching src/modules/Makefile.am
LIBFM_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LIBEXIF),y)
LIBFM_CONF_OPTS += --enable-exif
LIBFM_DEPENDENCIES += libexif
else
LIBFM_CONF_OPTS += --disable-exif
endif

ifeq ($(BR2_PACKAGE_LIBGTK3_X11),y)
LIBFM_CONF_OPTS += --with-gtk=3
LIBFM_DEPENDENCIES += libgtk3
else
LIBFM_CONF_OPTS += --with-gtk=2
LIBFM_DEPENDENCIES += libgtk2
endif

$(eval $(autotools-package))
