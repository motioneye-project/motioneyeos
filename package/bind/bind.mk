################################################################################
#
# bind
#
################################################################################

BIND_VERSION = 9.9.7-P2
BIND_SITE = ftp://ftp.isc.org/isc/bind9/$(BIND_VERSION)
BIND_INSTALL_STAGING = YES
BIND_CONFIG_SCRIPTS = bind9-config isc-config.sh
BIND_LICENSE = ISC
BIND_LICENSE_FILES = COPYRIGHT
BIND_TARGET_SERVER_SBIN = arpaname ddns-confgen dnssec-checkds dnssec-coverage
BIND_TARGET_SERVER_SBIN += dnssec-importkey dnssec-keygen dnssec-revoke
BIND_TARGET_SERVER_SBIN += dnssec-settime dnssec-verify genrandom
BIND_TARGET_SERVER_SBIN += isc-hmac-fixup named-journalprint nsec3hash
BIND_TARGET_SERVER_SBIN += lwresd named named-checkconf named-checkzone
BIND_TARGET_SERVER_SBIN += named-compilezone rndc rndc-confgen dnssec-dsfromkey
BIND_TARGET_SERVER_SBIN += dnssec-keyfromlabel dnssec-signzone
BIND_TARGET_TOOLS_BIN = dig host nslookup nsupdate
BIND_CONF_ENV = \
	BUILD_CC="$(TARGET_CC)" \
	BUILD_CFLAGS="$(TARGET_CFLAGS)"
BIND_CONF_OPTS = \
	--with-randomdev=/dev/urandom \
	--enable-epoll \
	--with-libtool \
	--with-gssapi=no \
	--enable-rrl \
	--enable-filter-aaaa

ifeq ($(BR2_PACKAGE_LIBCAP),y)
BIND_CONF_OPTS += --enable-linux-caps
BIND_DEPENDENCIES += libcap
else
BIND_CONF_OPTS += --disable-linux-caps
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
BIND_CONF_OPTS += --with-libxml2=$(STAGING_DIR)/usr --enable-newstats
BIND_DEPENDENCIES += libxml2
else
BIND_CONF_OPTS += --with-libxml2=no
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
BIND_DEPENDENCIES += openssl
BIND_CONF_ENV += \
	ac_cv_func_EVP_sha256=yes \
	ac_cv_func_EVP_sha384=yes \
	ac_cv_func_EVP_sha512=yes
BIND_CONF_OPTS += \
	--with-openssl=$(STAGING_DIR)/usr LIBS="-lz" \
	--with-ecdsa=yes
# GOST cipher support requires openssl extra engines
ifeq ($(BR2_PACKAGE_OPENSSL_ENGINES),y)
BIND_CONF_OPTS += --with-gost=yes
else
BIND_CONF_OPTS += --with-gost=no
endif
else
BIND_CONF_OPTS += --with-openssl=no
endif

# Used by dnssec-checkds and dnssec-coverage
ifeq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),)
BIND_CONF_OPTS += --with-python=no
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
BIND_DEPENDENCIES += readline
else
BIND_CONF_OPTS += --with-readline=no
endif

define BIND_TARGET_REMOVE_SERVER
	rm -rf $(addprefix $(TARGET_DIR)/usr/sbin/, $(BIND_TARGET_SERVER_SBIN))
endef

define BIND_TARGET_REMOVE_TOOLS
	rm -rf $(addprefix $(TARGET_DIR)/usr/bin/, $(BIND_TARGET_TOOLS_BIN))
endef

ifeq ($(BR2_PACKAGE_BIND_SERVER),y)
define BIND_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/bind/S81named \
		$(TARGET_DIR)/etc/init.d/S81named
endef
define BIND_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/bind/named.service \
		$(TARGET_DIR)/usr/lib/systemd/system/named.service

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -sf /usr/lib/systemd/system/named.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/named.service
endef
else
BIND_POST_INSTALL_TARGET_HOOKS += BIND_TARGET_REMOVE_SERVER
endif

ifeq ($(BR2_PACKAGE_BIND_TOOLS),)
BIND_POST_INSTALL_TARGET_HOOKS += BIND_TARGET_REMOVE_TOOLS
endif

define BIND_USERS
	named -1 named -1 * /etc/bind - - BIND daemon
endef

$(eval $(autotools-package))
