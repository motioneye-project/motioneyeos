################################################################################
#
# cups
#
################################################################################

CUPS_VERSION = 2.1.2
CUPS_SOURCE = cups-$(CUPS_VERSION)-source.tar.bz2
CUPS_SITE = http://www.cups.org/software/$(CUPS_VERSION)
CUPS_LICENSE = GPLv2 LGPLv2
CUPS_LICENSE_FILES = LICENSE.txt
CUPS_INSTALL_STAGING = YES
CUPS_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) DSTROOT=$(STAGING_DIR) install
CUPS_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) DSTROOT=$(TARGET_DIR) install

CUPS_CONF_OPTS = \
	--without-perl \
	--without-java \
	--without-php \
	--disable-gssapi \
	--libdir=/usr/lib
CUPS_CONFIG_SCRIPTS = cups-config
CUPS_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_ZLIB),zlib)

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
CUPS_CONF_OPTS += --with-systemd=/usr/lib/systemd/system \
	--enable-systemd
CUPS_DEPENDENCIES += systemd
else
CUPS_CONF_OPTS += --disable-systemd
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
CUPS_CONF_OPTS += --enable-dbus
CUPS_DEPENDENCIES += dbus
else
CUPS_CONF_OPTS += --disable-dbus
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
CUPS_CONF_OPTS += --enable-gnutls
CUPS_DEPENDENCIES += gnutls
else
CUPS_CONF_OPTS += --disable-gnutls
endif

ifeq ($(BR2_PACKAGE_PYTHON),y)
CUPS_CONF_OPTS += --with-python
CUPS_DEPENDENCIES += python
else
CUPS_CONF_OPTS += --without-python
endif

ifeq ($(BR2_PACKAGE_LIBUSB),y)
CUPS_CONF_OPTS += --enable-libusb
CUPS_DEPENDENCIES += libusb
else
CUPS_CONF_OPTS += --disable-libusb
endif

ifeq ($(BR2_PACKAGE_LIBPAPER),y)
CUPS_CONF_OPTS += --enable-libpaper
CUPS_DEPENDENCIES += libpaper
else
CUPS_CONF_OPTS += --disable-libpaper
endif

ifeq ($(BR2_PACKAGE_AVAHI),y)
CUPS_DEPENDENCIES += avahi
CUPS_CONF_OPTS += --enable-avahi
else
CUPS_CONF_OPTS += --disable-avahi
endif

$(eval $(autotools-package))
