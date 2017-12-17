################################################################################
#
# ibrdtnd
#
################################################################################

IBRDTND_VERSION = 1.0.1
IBRDTND_SITE = https://www.ibr.cs.tu-bs.de/projects/ibr-dtn/releases
IBRDTND_LICENSE = Apache-2.0
IBRDTND_LICENSE_FILES = COPYING
IBRDTND_DEPENDENCIES = ibrdtn ibrcommon host-pkgconf

# Disable features that don't have the necessary dependencies in
# Buildroot
IBRDTND_CONF_OPTS = \
	--disable-dtndht \
	--without-wifip2p \
	--without-vmime

# don't build documentation
IBRDTND_CONF_ENV = PDFLATEX='no'

ifeq ($(BR2_PACKAGE_LIBDAEMON),y)
IBRDTND_CONF_OPTS += --enable-libdaemon
IBRDTND_DEPENDENCIES += libdaemon
else
IBRDTND_CONF_OPTS += --disable-libdaemon
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
IBRDTND_CONF_OPTS += --with-curl
IBRDTND_DEPENDENCIES += libcurl
else
IBRDTND_CONF_OPTS += --without-curl
endif

ifeq ($(BR2_PACKAGE_SQLITE),y)
IBRDTND_CONF_OPTS += --with-sqlite
IBRDTND_DEPENDENCIES += sqlite
else
IBRDTND_CONF_OPTS += --without-sqlite
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
IBRDTND_CONF_OPTS += --with-tls
IBRDTND_DEPENDENCIES += openssl
else
IBRDTND_CONF_OPTS += --without-tls
endif

$(eval $(autotools-package))
