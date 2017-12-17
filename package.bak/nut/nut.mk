################################################################################
#
# nut
#
################################################################################

NUT_VERSION_MAJOR = 2.7
NUT_VERSION = $(NUT_VERSION_MAJOR).4
NUT_SITE = http://www.networkupstools.org/source/$(NUT_VERSION_MAJOR)
NUT_LICENSE = GPLv2+, GPLv3+ (python scripts), GPL/Artistic (perl client)
NUT_LICENSE_FILES = COPYING LICENSE-GPL2 LICENSE-GPL3
NUT_DEPENDENCIES = host-pkgconf

# Our patch changes m4 macros, so we need to autoreconf
NUT_AUTORECONF = YES

# Put the PID files in a read-write place (/var/run is a tmpfs)
# since the default location (/var/state/ups) maybe readonly.
NUT_CONF_OPTS = \
	--with-altpidpath=/var/run/upsd \
	--without-hal

# For uClibc-based toolchains, nut forgets to link with -lm
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
NUT_CONF_ENV += LDFLAGS="$(TARGET_LDFLAGS) -lm"
endif

ifeq ($(call qstrip,$(BR2_PACKAGE_NUT_DRIVERS)),)
NUT_CONF_OPTS += --with-drivers=all
else
NUT_CONF_OPTS += --with-drivers=$(BR2_PACKAGE_NUT_DRIVERS)
endif

ifeq ($(BR2_PACKAGE_AVAHI)$(BR2_PACKAGE_DBUS),yy)
NUT_DEPENDENCIES += avahi dbus
NUT_CONF_OPTS += --with-avahi
else
NUT_CONF_OPTS += --without-avahi
endif

# gd with support for png is required for the CGI
ifeq ($(BR2_PACKAGE_GD)$(BR2_PACKAGE_LIBPNG),yy)
NUT_DEPENDENCIES += gd libpng
NUT_CONF_OPTS += \
	--with-cgi \
	--with-gdlib-config=$(STAGING_DIR)/usr/bin/gdlib-config
else
NUT_CONF_OPTS += --without-cgi
endif

# nut-scanner needs libltdl, which is a wrapper arounf dlopen/dlsym,
# so is not available for static-only builds.
# There is no flag to directly enable/disable nut-scanner, it's done
# via the --enable/disable-libltdl flag.
ifeq ($(BR2_STATIC_LIBS):$(BR2_PACKAGE_LIBTOOL),:y)
NUT_DEPENDENCIES += libtool
NUT_CONF_OPTS += --with-libltdl
else
NUT_CONF_OPTS += --without-libltdl
endif

ifeq ($(BR2_PACKAGE_LIBUSB_COMPAT),y)
NUT_DEPENDENCIES += libusb-compat
NUT_CONF_OPTS += --with-usb
else
NUT_CONF_OPTS += --without-usb
endif

ifeq ($(BR2_PACKAGE_NEON_EXPAT)$(BR2_PACKAGE_NEON_LIBXML2),y)
NUT_DEPENDENCIES += neon
NUT_CONF_OPTS += --with-neon
else
NUT_CONF_OPTS += --without-neon
endif

ifeq ($(BR2_PACKAGE_NETSNMP),y)
NUT_DEPENDENCIES += netsnmp
NUT_CONF_OPTS += \
	--with-snmp \
	--with-net-snmp-config=$(STAGING_DIR)/usr/bin/net-snmp-config
else
NUT_CONF_OPTS += --without-snmp
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
NUT_DEPENDENCIES += openssl
NUT_CONF_OPTS += --with-ssl
else
NUT_CONF_OPTS += --without-ssl
endif

$(eval $(autotools-package))
