################################################################################
#
# unbound
#
################################################################################

UNBOUND_VERSION = 1.10.1
UNBOUND_SITE = https://www.unbound.net/downloads
UNBOUND_DEPENDENCIES = host-pkgconf expat libevent openssl
UNBOUND_LICENSE = BSD-3-Clause
UNBOUND_LICENSE_FILES = LICENSE
UNBOUND_CONF_OPTS = \
	--disable-rpath \
	--disable-debug \
	--with-conf-file=/etc/unbound/unbound.conf \
	--with-pidfile=/var/run/unbound.pid \
	--with-rootkey-file=/etc/unbound/root.key \
	--enable-tfo-server \
	--with-libexpat=$(STAGING_DIR)/usr \
	--with-ssl=$(STAGING_DIR)/usr

# uClibc-ng does not have MSG_FASTOPEN
# so TCP Fast Open client mode disabled for it
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
UNBOUND_CONF_OPTS += --disable-tfo-client
else
UNBOUND_CONF_OPTS += --enable-tfo-client
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS_NPTL),y)
UNBOUND_CONF_OPTS += --with-pthreads
else
UNBOUND_CONF_OPTS += --without-pthreads
endif

ifeq ($(BR2_GCC_ENABLE_LTO),y)
UNBOUND_CONF_OPTS += --enable-flto
else
UNBOUND_CONF_OPTS += --disable-flto
endif

ifeq ($(BR2_PACKAGE_UNBOUND_DNSCRYPT),y)
UNBOUND_CONF_OPTS += --enable-dnscrypt
UNBOUND_DEPENDENCIES += libsodium
else
UNBOUND_CONF_OPTS += --disable-dnscrypt
endif

define UNBOUND_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/unbound/S70unbound \
		$(TARGET_DIR)/etc/init.d/S70unbound
endef

$(eval $(autotools-package))
