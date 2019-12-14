################################################################################
#
# cups-filters
#
################################################################################

CUPS_FILTERS_VERSION = 1.26.0
CUPS_FILTERS_SITE = http://openprinting.org/download/cups-filters
CUPS_FILTERS_LICENSE = GPL-2.0, GPL-2.0+, GPL-3.0, GPL-3.0+, LGPL-2, LGPL-2.1+, MIT, BSD-4-Clause
CUPS_FILTERS_LICENSE_FILES = COPYING

CUPS_FILTERS_DEPENDENCIES = cups libglib2 lcms2 qpdf fontconfig freetype jpeg

CUPS_FILTERS_CONF_OPTS = --disable-imagefilters \
	--disable-mutool \
	--disable-foomatic \
	--disable-braille \
	--with-cups-config=$(STAGING_DIR)/usr/bin/cups-config \
	--with-sysroot=$(STAGING_DIR) \
	--with-pdftops=pdftops \
	--with-jpeg

ifeq ($(BR2_PACKAGE_LIBPNG),y)
CUPS_FILTERS_CONF_OPTS += --with-png
CUPS_FILTERS_DEPENDENCIES += libpng
else
CUPS_FILTERS_CONF_OPTS += --without-png
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
CUPS_FILTERS_CONF_OPTS += --with-tiff
CUPS_FILTERS_DEPENDENCIES += tiff
else
CUPS_FILTERS_CONF_OPTS += --without-tiff
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
CUPS_FILTERS_CONF_OPTS += --enable-dbus
CUPS_FILTERS_DEPENDENCIES += dbus
else
CUPS_FILTERS_CONF_OPTS += --disable-dbus
endif

# avahi support requires avahi-client, which needs avahi-daemon and dbus
ifeq ($(BR2_PACKAGE_AVAHI_DAEMON)$(BR2_PACKAGE_DBUS),yy)
CUPS_FILTERS_DEPENDENCIES += avahi
CUPS_FILTERS_CONF_OPTS += --enable-avahi
else
CUPS_FILTERS_CONF_OPTS += --disable-avahi
endif

ifeq ($(BR2_PACKAGE_GHOSTSCRIPT),y)
CUPS_FILTERS_DEPENDENCIES += ghostscript
CUPS_FILTERS_CONF_OPTS += --enable-ghostscript
else
CUPS_FILTERS_CONF_OPTS += --disable-ghostscript
endif

ifeq ($(BR2_PACKAGE_IJS),y)
CUPS_FILTERS_DEPENDENCIES += ijs
CUPS_FILTERS_CONF_OPTS += --enable-ijs
else
CUPS_FILTERS_CONF_OPTS += --disable-ijs
endif

ifeq ($(BR2_PACKAGE_POPPLER),y)
CUPS_FILTERS_DEPENDENCIES += poppler
CUPS_FILTERS_CONF_OPTS += --enable-poppler
else
CUPS_FILTERS_CONF_OPTS += --disable-poppler
endif

$(eval $(autotools-package))
