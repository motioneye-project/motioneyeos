################################################################################
#
# openldap
#
################################################################################

OPENLDAP_VERSION = 2.4.40
OPENLDAP_SOURCE = openldap-$(OPENLDAP_VERSION).tgz
OPENLDAP_SITE = ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release
OPENLDAP_LICENSE = OpenLDAP Public License
OPENLDAP_LICENSE_FILES = LICENSE
OPENLDAP_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_OPENSSL),y)
OPENLDAP_TLS = openssl
OPENLDAP_DEPENDENCIES += openssl
else ifeq ($(BR2_PACKAGE_GNUTLS),y)
OPENLDAP_TLS = gnutls
OPENLDAP_DEPENDENCIES += gnutls
else ifeq ($(BR2_PACKAGE_LIBNSS),y)
OPENLDAP_TLS = moznss
OPENLDAP_DEPENDENCIES += libnss
OPENLDAP_CPPFLAGS = \
	-I$(STAGING_DIR)/usr/include/nss \
	-I$(STAGING_DIR)/usr/include/nspr
else
OPENLDAP_TLS = no
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
OPENLDAP_MP = bignum
OPENLDAP_DEPENDENCIES += openssl
else ifeq ($(BR2_PACKAGE_GMP),y)
OPENLDAP_MP = gmp
OPENLDAP_DEPENDENCIES += gmp
else
OPENLDAP_MP = longlong
endif

OPENLDAP_CONF_ENV = ac_cv_func_memcmp_working=yes

OPENLDAP_CONF_OPTS += \
	--enable-syslog \
	--disable-proctitle \
	--disable-slapd \
	--with-yielding-select \
	--sysconfdir=/etc \
	--enable-dynamic=$(if $(BR2_STATIC_LIBS),no,yes) \
	--with-tls=$(OPENLDAP_TLS) \
	--with-mp=$(OPENLDAP_MP) \
	CPPFLAGS="$(TARGET_CPPFLAGS) $(OPENLDAP_CPPFLAGS)"

# Somehow, ${STRIP} does not percolates through to the shtool script
# used to install the executables; thus, that script tries to run the
# executable it is supposed to install, resulting in an error.
OPENLDAP_MAKE_ENV = STRIP="$(TARGET_STRIP)"

$(eval $(autotools-package))
