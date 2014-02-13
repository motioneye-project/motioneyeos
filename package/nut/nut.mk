################################################################################
#
# nut
#
################################################################################

NUT_VERSION_MAJOR = 2.6
NUT_VERSION = $(NUT_VERSION_MAJOR).5
NUT_SITE = http://www.networkupstools.org/source/$(NUT_VERSION_MAJOR)/
NUT_LICENSE = GPLv2+, GPLv3+ (python scripts), GPL/Artistic (perl client)
NUT_LICENSE_FILES = COPYING LICENSE-GPL2 LICENSE-GPL3
NUT_DEPENDENCIES = host-pkgconf

# Our patch changes m4 macros, so we need to autoreconf
NUT_AUTORECONF = YES

# Disable parallel builds
NUT_MAKE = $(MAKE1)

# Put the PID files in a read-write place (/var/run is a tmpfs)
# since the default location (/var/state/ups) maybe readonly.
NUT_CONF_OPT = \
	--with-altpidpath=/var/run/upsd \
	--without-hal

NUT_CONF_ENV = \
	GDLIB_CONFIG=$(STAGING_DIR)/usr/bin/gdlib-config \
	NET_SNMP_CONFIG=$(STAGING_DIR)/usr/bin/net-snmp-config

# For uClibc-based toolchains, nut forgets to link with -lm
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
NUT_CONF_ENV += LDFLAGS="$(TARGET_LDFLAGS) -lm"
endif

ifeq ($(call qstrip,$(BR2_PACKAGE_NUT_DRIVERS)),)
NUT_CONF_OPT += --with-drivers=all
else
NUT_CONF_OPT += --with-drivers=$(BR2_PACKAGE_NUT_DRIVERS)
endif

ifeq ($(BR2_PACKAGE_AVAHI)$(BR2_PACKAGE_DBUS),yy)
NUT_DEPENDENCIES += avahi dbus
NUT_CONF_OPT += --with-avahi
else
NUT_CONF_OPT += --without-avahi
endif

# gd with support for png is required for the CGI
ifeq ($(BR2_PACKAGE_GD)$(BR2_PACKAGE_LIBPNG),yy)
NUT_DEPENDENCIES += gd libpng
NUT_CONF_OPT += --with-cgi
else
NUT_CONF_OPT += --without-cgi
endif

# libltdl (libtool) is needed for nut-scanner
ifeq ($(BR2_PACKAGE_LIBTOOL),y)
NUT_DEPENDENCIES += libtool
NUT_CONF_OPT += --with-libltdl
else
NUT_CONF_OPT += --without-libltdl
endif

ifeq ($(BR2_PACKAGE_LIBUSB_COMPAT),y)
NUT_DEPENDENCIES += libusb-compat
NUT_CONF_OPT += --with-usb
else
NUT_CONF_OPT += --without-usb
endif

ifeq ($(BR2_PACKAGE_NEON_EXPAT)$(BR2_PACKAGE_NEON_LIBXML2),y)
NUT_DEPENDENCIES += neon
NUT_CONF_OPT += --with-neon
else
NUT_CONF_OPT += --without-neon
endif

ifeq ($(BR2_PACKAGE_NETSNMP),y)
NUT_DEPENDENCIES += netsnmp
NUT_CONF_OPT += --with-snmp
else
NUT_CONF_OPT += --without-snmp
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
NUT_DEPENDENCIES += openssl
NUT_CONF_OPT += --with-ssl
else
NUT_CONF_OPT += --without-ssl
endif

$(eval $(autotools-package))
