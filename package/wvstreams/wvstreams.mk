################################################################################
#
# wvstreams
#
################################################################################

WVSTREAMS_VERSION = 4.6.1
WVSTREAMS_SITE = http://wvstreams.googlecode.com/files
WVSTREAMS_DEPENDENCIES = openssl zlib host-pkgconf
WVSTREAMS_INSTALL_STAGING = YES

WVSTREAMS_LICENSE = LGPLv2+
WVSTREAMS_LICENSE_FILES = LICENSE

# N.B. parallel make fails
WVSTREAMS_MAKE = $(MAKE1)

# Needed to work around problem with wvassert.h
WVSTREAMS_CONF_OPT += CPPFLAGS=-DNDEBUG

WVSTREAMS_CONF_OPT += \
	--with-openssl \
	--with-zlib \
	--without-pam \
	--disable-warnings

# needed for openssl detection when statically linking (as ssl needs lz)
WVSTREAMS_CONF_ENV += LIBS=-lz

ifneq ($(BR2_PREFER_STATIC_LIB),y)
	WVSTREAMS_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -fPIC"
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
	WVSTREAMS_DEPENDENCIES += dbus
	WVSTREAMS_CONF_OPT += --with-dbus
else
	WVSTREAMS_CONF_OPT += --without-dbus
endif

ifeq ($(BR2_PACKAGE_TCL),y)
	WVSTREAMS_DEPENDENCIES += tcl
	WVSTREAMS_CONF_OPT += --with-tcl
else
	WVSTREAMS_CONF_OPT += --without-tcl
endif

ifeq ($(BR2_PACKAGE_QT),y)
	WVSTREAMS_DEPENDENCIES += qt
	WVSTREAMS_CONF_OPT += --with-qt
else
	WVSTREAMS_CONF_OPT += --without-qt
endif

ifeq ($(BR2_PACKAGE_VALGRIND),y)
	WVSTREAMS_DEPENDENCIES += valgrind
	WVSTREAMS_CONF_OPT += --with-valgrind
else
	WVSTREAMS_CONF_OPT += --without-valgrind
endif

$(eval $(autotools-package))
