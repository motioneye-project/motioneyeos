################################################################################
#
# imlib2
#
################################################################################

IMLIB2_VERSION = 1.4.9
IMLIB2_SOURCE = imlib2-$(IMLIB2_VERSION).tar.bz2
IMLIB2_SITE = http://downloads.sourceforge.net/project/enlightenment/imlib2-src/$(IMLIB2_VERSION)
IMLIB2_LICENSE = imlib2 license
IMLIB2_LICENSE_FILES = COPYING

IMLIB2_AUTORECONF = YES
IMLIB2_INSTALL_STAGING = YES
IMLIB2_DEPENDENCIES = host-pkgconf freetype
IMLIB2_CONF_OPTS = --with-freetype-config=$(STAGING_DIR)/usr/bin/freetype-config
IMLIB2_CONFIG_SCRIPTS = imlib2-config

ifeq ($(BR2_PACKAGE_IMLIB2_X),y)
IMLIB2_CONF_OPTS += --with-x
IMLIB2_DEPENDENCIES += xlib_libX11 xlib_libXext
else
IMLIB2_CONF_OPTS += --without-x
endif

ifeq ($(BR2_PACKAGE_IMLIB2_JPEG),y)
IMLIB2_CONF_OPTS += --with-jpeg
IMLIB2_DEPENDENCIES += jpeg
else
IMLIB2_CONF_OPTS += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_IMLIB2_PNG),y)
IMLIB2_CONF_OPTS += --with-png
IMLIB2_DEPENDENCIES += libpng
else
IMLIB2_CONF_OPTS += --without-png
endif

ifeq ($(BR2_PACKAGE_IMLIB2_GIF),y)
IMLIB2_CONF_OPTS += --with-gif
IMLIB2_DEPENDENCIES += giflib
else
IMLIB2_CONF_OPTS += --without-gif
endif

ifeq ($(BR2_PACKAGE_IMLIB2_TIFF),y)
IMLIB2_CONF_OPTS += --with-tiff
IMLIB2_DEPENDENCIES += tiff
else
IMLIB2_CONF_OPTS += --without-tiff
endif

ifeq ($(BR2_PACKAGE_IMLIB2_ID3),y)
IMLIB2_CONF_OPTS += --with-id3
IMLIB2_DEPENDENCIES += libid3tag
else
IMLIB2_CONF_OPTS += --without-id3
endif

# drop -L<dir> from linker flags
define IMLIB2_FIXUP_IMLIB2_CONFIG
	$(SED) 's/-L[^ ]*//g' $(STAGING_DIR)/usr/bin/imlib2-config
endef

IMLIB2_POST_INSTALL_STAGING_HOOKS += IMLIB2_FIXUP_IMLIB2_CONFIG

$(eval $(autotools-package))
