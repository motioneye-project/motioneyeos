################################################################################
#
# pure-ftpd
#
################################################################################

PURE_FTPD_VERSION = 1.0.47
PURE_FTPD_SITE = https://download.pureftpd.org/pub/pure-ftpd/releases
PURE_FTPD_SOURCE = pure-ftpd-$(PURE_FTPD_VERSION).tar.bz2
PURE_FTPD_LICENSE = ISC
PURE_FTPD_LICENSE_FILES = COPYING
PURE_FTPD_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBICONV),libiconv)

PURE_FTPD_CONF_OPTS = \
	--with-altlog \
	--with-puredb \
	--with-rfc2640

ifeq ($(BR2_PACKAGE_ELFUTILS),y)
PURE_FTPD_DEPENDENCIES += elfutils
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
PURE_FTPD_CONF_OPTS += --with-capabilities
PURE_FTPD_DEPENDENCIES += libcap
else
PURE_FTPD_CONF_OPTS += --without-capabilities
endif

ifeq ($(BR2_PACKAGE_LIBSODIUM),y)
PURE_FTPD_DEPENDENCIES += libsodium
endif

ifeq ($(BR2_PACKAGE_OPENLDAP),y)
PURE_FTPD_CONF_OPTS += --with-ldap
PURE_FTPD_DEPENDENCIES += openldap
else
PURE_FTPD_CONF_OPTS += --without-ldap
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
PURE_FTPD_CONF_OPTS += --with-tls
PURE_FTPD_DEPENDENCIES += openssl
ifeq ($(BR2_STATIC_LIBS),y)
PURE_FTPD_CONF_ENV += LIBS='-lssl -lcrypto -lz'
endif
else
PURE_FTPD_CONF_OPTS += --without-tls
endif

ifeq ($(BR2_TOOLCHAIN_SUPPORTS_PIE),)
PURE_FTPD_CONF_ENV += ax_cv_check_cflags___fPIE=no ax_cv_check_ldflags___fPIE=no
endif

ifeq ($(BR2_PACKAGE_PURE_FTPD_FTPWHO),y)
PURE_FTPD_CONF_OPTS += --with-ftpwho
endif

ifeq ($(BR2_PACKAGE_PURE_FTPD_QUOTAS),y)
PURE_FTPD_CONF_OPTS += --with-quotas
endif

ifeq ($(BR2_PACKAGE_PURE_FTPD_UPLOADSCRIPT),y)
PURE_FTPD_CONF_OPTS += --with-uploadscript
endif

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
PURE_FTPD_CONF_OPTS += --with-pam
PURE_FTPD_DEPENDENCIES += linux-pam
else
PURE_FTPD_CONF_OPTS += --without-pam
endif

$(eval $(autotools-package))
