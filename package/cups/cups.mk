################################################################################
#
# cups
#
################################################################################

CUPS_VERSION = 1.3.11
CUPS_SOURCE = cups-$(CUPS_VERSION)-source.tar.bz2
CUPS_SITE = http://www.cups.org/software/$(CUPS_VERSION)
CUPS_LICENSE = GPLv2 LGPLv2
CUPS_LICENSE_FILES = LICENSE.txt
CUPS_INSTALL_STAGING = YES
CUPS_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) DSTROOT=$(STAGING_DIR) install
CUPS_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) DSTROOT=$(TARGET_DIR) install
CUPS_CONF_OPT = --without-perl \
		--without-java \
		--disable-gnutls \
		--disable-gssapi \
		--libdir=/usr/lib
CUPS_CONFIG_SCRIPTS = cups-config

CUPS_DEPENDENCIES = $(if $(BR2_PACKAGE_ZLIB),zlib) \
		    $(if $(BR2_PACKAGE_LIBPNG),libpng) \
		    $(if $(BR2_PACKAGE_JPEG),jpeg) \
		    $(if $(BR2_PACKAGE_TIFF),tiff)

ifeq ($(BR2_PACKAGE_DBUS),y)
	CUPS_CONF_OPT += --enable-dbus
	CUPS_DEPENDENCIES += dbus
else
	CUPS_CONF_OPT += --disable-dbus
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
	CUPS_DEPENDENCIES += xlib_libX11
endif

ifeq ($(BR2_PACKAGE_PHP),y)
	CUPS_CONF_ENV += ac_cv_path_PHPCONFIG=$(STAGING_DIR)/usr/bin/php-config
	CUPS_CONF_OPT += --with-php
	CUPS_DEPENDENCIES += php
else
	CUPS_CONF_OPT += --without-php
endif

ifeq ($(BR2_PACKAGE_PYTHON),y)
	CUPS_CONF_OPT += --with-python
	CUPS_DEPENDENCIES += python
else
	CUPS_CONF_OPT += --without-python
endif

ifeq ($(BR2_PACKAGE_CUPS_PDFTOPS),y)
	CUPS_CONF_OPT += --enable-pdftops
else
	CUPS_CONF_OPT += --disable-pdftops
endif

# standard autoreconf fails with autoheader failures
define CUPS_FIXUP_AUTOCONF
	cd $(@D) && $(AUTOCONF)
endef
CUPS_DEPENDENCIES += host-autoconf

CUPS_PRE_CONFIGURE_HOOKS += CUPS_FIXUP_AUTOCONF

$(eval $(autotools-package))
