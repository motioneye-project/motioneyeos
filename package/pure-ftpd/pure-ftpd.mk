################################################################################
#
# pure-ftpd
#
################################################################################

PURE_FTPD_VERSION = 1.0.36
PURE_FTPD_SITE = http://download.pureftpd.org/pub/pure-ftpd/releases
PURE_FTPD_LICENSE = ISC
PURE_FTPD_LICENSE_FILES = COPYING
PURE_FTPD_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBICONV),libiconv)

PURE_FTPD_CONF_OPTS = \
	--with-altlog \
	--with-puredb \
	--with-rfc2640

ifeq ($(BR2_PACKAGE_LIBCAP),y)
PURE_FTPD_CONF_OPTS += --with-capabilities
PURE_FTPD_DEPENDENCIES += libcap
else
PURE_FTPD_CONF_OPTS += --without-capabilities
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
PURE_FTPD_CONF_OPTS += --with-tls
PURE_FTPD_DEPENDENCIES += openssl
ifeq ($(BR2_PREFER_STATIC_LIB),y)
PURE_FTPD_CONF_ENV += LIBS='-lssl -lcrypto -lz'
endif
else
PURE_FTPD_CONF_OPTS += --without-tls
endif

$(eval $(autotools-package))
