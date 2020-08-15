################################################################################
#
# squid
#
################################################################################

SQUID_VERSION = 4.12
SQUID_SOURCE = squid-$(SQUID_VERSION).tar.xz
SQUID_SITE = http://www.squid-cache.org/Versions/v4
SQUID_LICENSE = GPL-2.0+
SQUID_LICENSE_FILES = COPYING
SQUID_DEPENDENCIES = libcap host-libcap libxml2 host-pkgconf \
	$(if $(BR2_PACKAGE_LIBNETFILTER_CONNTRACK),libnetfilter_conntrack)
SQUID_CONF_ENV = \
	ac_cv_epoll_works=yes \
	ac_cv_func_setresuid=yes \
	ac_cv_func_va_copy=yes \
	ac_cv_func___va_copy=yes \
	ac_cv_func_strnstr=no \
	ac_cv_have_squid=yes \
	BUILDCXX="$(HOSTCXX)" \
	BUILDCXXFLAGS="$(HOST_CXXFLAGS)"
SQUID_CONF_OPTS = \
	--enable-async-io=8 \
	--enable-linux-netfilter \
	--enable-removal-policies="lru,heap" \
	--with-filedescriptors=1024 \
	--disable-ident-lookups \
	--enable-auth-basic="fake getpwnam" \
	--enable-auth-digest="file" \
	--enable-auth-negotiate="wrapper" \
	--enable-auth-ntlm="fake" \
	--disable-strict-error-checking \
	--enable-external-acl-helpers="file_userip" \
	--with-logdir=/var/log/squid/ \
	--with-pidfile=/var/run/squid.pid \
	--with-swapdir=/var/cache/squid/ \
	--with-default-user=squid

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
SQUID_CONF_ENV += LIBS=-latomic
endif

ifeq ($(BR2_PACKAGE_LIBKRB5),y)
SQUID_CONF_OPTS += --with-mit-krb5
SQUID_DEPENDENCIES += libkrb5
else
SQUID_CONF_OPTS += --without-mit-krb5
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
SQUID_CONF_OPTS += --with-openssl
SQUID_DEPENDENCIES += openssl
else
SQUID_CONF_OPTS += --without-openssl
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
SQUID_CONF_OPTS += --with-gnutls
SQUID_DEPENDENCIES += gnutls
else
SQUID_CONF_OPTS += --without-gnutls
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
SQUID_CONF_OPTS += --with-systemd
SQUID_DEPENDENCIES += systemd
else
SQUID_CONF_OPTS += --without-systemd
endif

define SQUID_CLEANUP_TARGET
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, \
		RunCache RunAccel)
	rm -f $(addprefix $(TARGET_DIR)/etc/, \
		cachemgr.conf mime.conf.default squid.conf.default)
endef

SQUID_POST_INSTALL_TARGET_HOOKS += SQUID_CLEANUP_TARGET

define SQUID_USERS
	squid -1 squid -1 * - - - Squid proxy cache
endef

define SQUID_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/squid/S97squid \
		$(TARGET_DIR)/etc/init.d/S97squid
endef

define SQUID_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(@D)/tools/systemd/squid.service \
		$(TARGET_DIR)/usr/lib/systemd/system/squid.service
endef

$(eval $(autotools-package))
