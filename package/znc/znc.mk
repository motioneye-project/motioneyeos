################################################################################
#
# znc
#
################################################################################

ZNC_VERSION = 1.6.3
ZNC_SITE = http://znc.in/releases
ZNC_LICENSE = Apache-2.0
ZNC_LICENSE_FILES = LICENSE
ZNC_DEPENDENCIES = host-pkgconf
ZNC_CONF_OPTS = --disable-perl

ifeq ($(BR2_PACKAGE_ICU),y)
ZNC_DEPENDENCIES += icu
ZNC_CONF_OPTS += --enable-charset
else
ZNC_CONF_OPTS += --disable-charset
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
ZNC_DEPENDENCIES += openssl
ZNC_CONF_OPTS += --enable-openssl
else
ZNC_CONF_OPTS += --disable-openssl
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
ZNC_DEPENDENCIES += zlib
ZNC_CONF_OPTS += --enable-zlib
else
ZNC_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_PYTHON3),y)
ZNC_DEPENDENCIES += python3 host-swig
ZNC_CONF_OPTS += --enable-python=python3
else
ZNC_CONF_OPTS += --disable-python
endif

$(eval $(autotools-package))
