################################################################################
#
# openldap
#
################################################################################

OPENLDAP_VERSION = 2.4.50
OPENLDAP_SOURCE = openldap-$(OPENLDAP_VERSION).tgz
OPENLDAP_SITE = https://www.openldap.org/software/download/OpenLDAP/openldap-release
OPENLDAP_LICENSE = OpenLDAP Public License
OPENLDAP_LICENSE_FILES = LICENSE
OPENLDAP_INSTALL_STAGING = YES
OPENLDAP_DEPENDENCIES = host-pkgconf

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
OPENLDAP_CONF_ENV = LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs libssl libcrypto`"
else ifeq ($(BR2_PACKAGE_GMP),y)
OPENLDAP_MP = gmp
OPENLDAP_DEPENDENCIES += gmp
else
OPENLDAP_MP = longlong
endif

OPENLDAP_CONF_ENV += ac_cv_func_memcmp_working=yes

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

ifeq ($(BR2_PACKAGE_OPENLDAP_CLIENTS),)
OPENLDAP_CLIENTS = \
	ldapurl ldapexop ldapcompare ldapwhoami \
	ldappasswd ldapmodrdn ldapdelete ldapmodify \
	ldapsearch
define OPENLDAP_REMOVE_CLIENTS
	$(RM) -f $(foreach p,$(OPENLDAP_CLIENTS),$(TARGET_DIR)/usr/bin/$(p))
	$(RM) -rf $(TARGET_DIR)/etc/openldap
endef
OPENLDAP_POST_INSTALL_TARGET_HOOKS += OPENLDAP_REMOVE_CLIENTS
endif

$(eval $(autotools-package))
