################################################################################
#
# postgresql
#
################################################################################

POSTGRESQL_VERSION = 9.4.1
POSTGRESQL_SOURCE = postgresql-$(POSTGRESQL_VERSION).tar.bz2
POSTGRESQL_SITE = http://ftp.postgresql.org/pub/source/v$(POSTGRESQL_VERSION)
POSTGRESQL_LICENSE = PostgreSQL
POSTGRESQL_LICENSE_FILES = COPYRIGHT

POSTGRESQL_INSTALL_STAGING = YES
POSTGRESQL_CONFIG_SCRIPTS = pg_config

ifneq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
	POSTGRESQL_CONF_OPTS += --disable-thread-safety
endif

ifeq ($(BR2_microblazeel)$(BR2_microblazebe)$(BR2_nios2),y)
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
	POSTGRESQL_CONF_ENV += ZIC=$$(ZIC)
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
	POSTGRESQL_DEPENDENCIES += openssl
	POSTGRESQL_CONF_OPTS += --with-openssl
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
		$(TARGET_DIR)/etc/systemd/system/postgresql.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../postgresql.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/postgresql.service
endef

$(eval $(autotools-package))
