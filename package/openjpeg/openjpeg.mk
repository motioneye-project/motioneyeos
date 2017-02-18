################################################################################
#
# openjpeg
#
################################################################################

OPENJPEG_VERSION = 1.5.2
OPENJPEG_SITE = http://downloads.sourceforge.net/project/openjpeg.mirror/$(OPENJPEG_VERSION)
OPENJPEG_LICENSE = BSD-2c
OPENJPEG_LICENSE_FILES = LICENSE
# tarball does not contain the generated files
OPENJPEG_AUTORECONF = YES
OPENJPEG_INSTALL_STAGING = YES
OPENJPEG_DEPENDENCIES = host-pkgconf
OPENJPEG_CONF_OPTS = --disable-lcms1

ifeq ($(BR2_PACKAGE_LIBPNG),y)
OPENJPEG_DEPENDENCIES += libpng
OPENJPEG_CONF_OPTS += --enable-png
else
OPENJPEG_CONF_OPTS += --disable-png
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
OPENJPEG_DEPENDENCIES += tiff
OPENJPEG_CONF_OPTS += --enable-tiff
else
OPENJPEG_CONF_OPTS += --disable-tiff
endif

ifeq ($(BR2_PACKAGE_LCMS2),y)
OPENJPEG_DEPENDENCIES += lcms2
OPENJPEG_CONF_OPTS += --enable-lcms2
else
OPENJPEG_CONF_OPTS += --disable-lcms2
endif

$(eval $(autotools-package))
