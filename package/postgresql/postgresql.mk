################################################################################
#
# postgresql
#
################################################################################

POSTGRESQL_VERSION = 10.5
POSTGRESQL_SOURCE = postgresql-$(POSTGRESQL_VERSION).tar.bz2
POSTGRESQL_SITE = http://ftp.postgresql.org/pub/source/v$(POSTGRESQL_VERSION)
POSTGRESQL_LICENSE = PostgreSQL
POSTGRESQL_LICENSE_FILES = COPYRIGHT
POSTGRESQL_INSTALL_STAGING = YES
POSTGRESQL_CONFIG_SCRIPTS = pg_config
POSTGRESQL_CONF_ENV = \
	ac_cv_type_struct_sockaddr_in6=yes \
	pgac_cv_snprintf_long_long_int_modifier="ll" \
	pgac_cv_snprintf_size_t_support=yes
POSTGRESQL_CONF_OPTS = --disable-rpath

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
# PostgreSQL does not build against uClibc with locales
# enabled, due to an uClibc bug, see
# http://lists.uclibc.org/pipermail/uclibc/2014-April/048326.html
# so overwrite automatic detection and disable locale support
POSTGRESQL_CONF_ENV += pgac_cv_type_locale_t=no
endif

ifneq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
POSTGRESQL_CONF_OPTS += --disable-thread-safety
endif

ifeq ($(BR2_arcle)$(BR2_arceb)$(BR2_microblazeel)$(BR2_microblazebe)$(BR2_or1k)$(BR2_nios2)$(BR2_xtensa),y)
POSTGRESQL_CONF_OPTS += --disable-spinlocks
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
POSTGRESQL_DEPENDENCIES += readline
else
POSTGRESQL_CONF_OPTS += --without-readline
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
POSTGRESQL_DEPENDENCIES += zlib
else
POSTGRESQL_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_TZDATA),y)
POSTGRESQL_DEPENDENCIES += tzdata
POSTGRESQL_CONF_OPTS += --with-system-tzdata=/usr/share/zoneinfo
else
POSTGRESQL_DEPENDENCIES += host-zic
POSTGRESQL_CONF_ENV += ZIC="$(ZIC)"
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
POSTGRESQL_DEPENDENCIES += openssl
POSTGRESQL_CONF_OPTS += --with-openssl
else
# PostgreSQL checks for /dev/urandom and fails if it's being cross-compiled and
# an SSL library isn't found. Since /dev/urandom is guaranteed to be provided
# on Linux systems, explicitly tell the configure script it's available.
POSTGRESQL_CONF_ENV += ac_cv_file__dev_urandom=yes
endif

ifeq ($(BR2_PACKAGE_OPENLDAP),y)
POSTGRESQL_DEPENDENCIES += openldap
POSTGRESQL_CONF_OPTS += --with-ldap
else
POSTGRESQL_CONF_OPTS += --without-ldap
endif

define POSTGRESQL_USERS
	postgres -1 postgres -1 * /var/lib/pgsql /bin/sh - PostgreSQL Server
endef

define POSTGRESQL_INSTALL_TARGET_FIXUP
	$(INSTALL) -dm 0700 $(TARGET_DIR)/var/lib/pgsql
	$(RM) -rf $(TARGET_DIR)/usr/lib/postgresql/pgxs
endef

POSTGRESQL_POST_INSTALL_TARGET_HOOKS += POSTGRESQL_INSTALL_TARGET_FIXUP

define POSTGRESQL_INSTALL_CUSTOM_PG_CONFIG
	$(INSTALL) -m 0755 -D package/postgresql/pg_config \
		$(STAGING_DIR)/usr/bin/pg_config
endef

POSTGRESQL_POST_INSTALL_STAGING_HOOKS += POSTGRESQL_INSTALL_CUSTOM_PG_CONFIG

define POSTGRESQL_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/postgresql/S50postgresql \
		$(TARGET_DIR)/etc/init.d/S50postgresql
endef

define POSTGRESQL_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/postgresql/postgresql.service \
		$(TARGET_DIR)/usr/lib/systemd/system/postgresql.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/postgresql.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/postgresql.service
endef

$(eval $(autotools-package))
