################################################################################
#
# libfm
#
################################################################################

LIBFM_VERSION = 1.2.3
LIBFM_SOURCE = libfm-$(LIBFM_VERSION).tar.xz
LIBFM_SITE = http://sourceforge.net/projects/pcmanfm/files
LIBFM_DEPENDENCIES = menu-cache libgtk2 libglib2 cairo
LIBFM_LICENSE = GPLv2+, LGPLv2.1+
LIBFM_LICENSE_FILES = COPYING src/extra/fm-xml-file.c
LIBFM_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_LIBEXIF),y)
LIBFM_CONF_OPTS += --enable-exif
LIBFM_DEPENDENCIES += libexif
else
LIBFM_CONF_OPTS += --disable-exif
endif

$(eval $(autotools-package))
