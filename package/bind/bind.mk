################################################################################
#
# bind
#
################################################################################

BIND_VERSION = 9.11.20
BIND_SITE = https://ftp.isc.org/isc/bind9/$(BIND_VERSION)
# bind does not support parallel builds.
BIND_MAKE = $(MAKE1)
BIND_INSTALL_STAGING = YES
BIND_CONFIG_SCRIPTS = bind9-config isc-config.sh
BIND_LICENSE = MPL-2.0
BIND_LICENSE_FILES = COPYRIGHT
BIND_TARGET_SERVER_SBIN = arpaname ddns-confgen dnssec-checkds dnssec-coverage
BIND_TARGET_SERVER_SBIN += dnssec-importkey dnssec-keygen dnssec-revoke
BIND_TARGET_SERVER_SBIN += dnssec-settime dnssec-verify genrandom
BIND_TARGET_SERVER_SBIN += isc-hmac-fixup named-journalprint nsec3hash
BIND_TARGET_SERVER_SBIN += lwresd named named-checkconf named-checkzone
BIND_TARGET_SERVER_SBIN += named-compilezone rndc rndc-confgen dnssec-dsfromkey
BIND_TARGET_SERVER_SBIN += dnssec-keyfromlabel dnssec-signzone tsig-keygen
BIND_TARGET_TOOLS_BIN = dig host nslookup nsupdate
BIND_CONF_ENV = \
	BUILD_CC="$(TARGET_CC)" \
	BUILD_CFLAGS="$(TARGET_CFLAGS)"
BIND_CONF_OPTS = \
	$(if $(BR2_TOOLCHAIN_HAS_THREADS),--enable-threads,--disable-threads) \
	--without-lmdb \
	--with-libjson=no \
	--with-randomdev=/dev/urandom \
	--enable-epoll \
	--with-gssapi=no \
	--enable-filter-aaaa

ifeq ($(BR2_PACKAGE_ZLIB),y)
BIND_CONF_OPTS += --with-zlib=$(STAGING_DIR)/usr
BIND_DEPENDENCIES += zlib
else
BIND_CONF_OPTS += --without-zlib
endif

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
BIND_DEPENDENCIES += host-pkgconf openssl
BIND_CONF_OPTS += \
	--with-openssl=$(STAGING_DIR)/usr \
	--with-ecdsa=yes \
	--with-eddsa=no \
	--with-aes=yes
BIND_CONF_ENV += LIBS=`$(PKG_CONFIG_HOST_BINARY) --libs openssl`
# GOST cipher support requires openssl extra engines
ifeq ($(BR2_PACKAGE_OPENSSL_ENGINES),y)
BIND_CONF_OPTS += --with-gost=yes
else
BIND_CONF_OPTS += --with-gost=no
endif
else
BIND_CONF_OPTS += --with-openssl=no
endif

# Used by dnssec-keymgr
ifeq ($(BR2_PACKAGE_PYTHON_PLY),y)
BIND_DEPENDENCIES += host-python-ply
BIND_CONF_OPTS += --with-python=$(HOST_DIR)/usr/bin/python
else
BIND_CONF_OPTS += --with-python=no
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
BIND_DEPENDENCIES += readline
else
BIND_CONF_OPTS += --with-readline=no
endif

ifeq ($(BR2_STATIC_LIBS),y)
BIND_CONF_OPTS += \
	--without-dlopen \
	--without-libtool
else
BIND_CONF_OPTS += \
	--with-dlopen \
	--with-libtool
endif

define BIND_TARGET_REMOVE_SERVER
	rm -rf $(addprefix $(TARGET_DIR)/usr/sbin/, $(BIND_TARGET_SERVER_SBIN))
endef

define BIND_TARGET_REMOVE_TOOLS
	rm -rf $(addprefix $(TARGET_DIR)/usr/bin/, $(BIND_TARGET_TOOLS_BIN))
endef

ifeq ($(BR2_PACKAGE_BIND_SERVER),y)
define BIND_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D $(BIND_PKGDIR)/S81named \
		$(TARGET_DIR)/etc/init.d/S81named
endef
define BIND_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(BIND_PKGDIR)/named.service \
		$(TARGET_DIR)/usr/lib/systemd/system/named.service
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
