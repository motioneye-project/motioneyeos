################################################################################
#
# cups
#
################################################################################

CUPS_VERSION = 2.3.1
CUPS_SOURCE = cups-$(CUPS_VERSION)-source.tar.gz
CUPS_SITE = https://github.com/apple/cups/releases/download/v$(CUPS_VERSION)
CUPS_LICENSE = Apache-2.0 with GPL-2.0/LGPL-2.0 exception
CUPS_LICENSE_FILES = LICENSE NOTICE
CUPS_INSTALL_STAGING = YES

# Using autoconf, not autoheader, so we cannot use AUTORECONF = YES.
define CUPS_RUN_AUTOCONF
	cd $(@D); $(AUTOCONF) -f
endef
CUPS_PRE_CONFIGURE_HOOKS += CUPS_RUN_AUTOCONF

CUPS_CONF_OPTS = \
	--with-docdir=/usr/share/cups/doc-root \
	--disable-gssapi \
	--disable-pam \
	--libdir=/usr/lib
CUPS_CONFIG_SCRIPTS = cups-config
CUPS_DEPENDENCIES = \
	host-autoconf \
	host-pkgconf \
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
