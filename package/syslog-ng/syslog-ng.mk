################################################################################
#
# syslog-ng
#
################################################################################

# When updating the version, please check at runtime if the version in
# syslog-ng.conf header needs to be updated
SYSLOG_NG_VERSION = 3.19.1
SYSLOG_NG_SITE = https://github.com/balabit/syslog-ng/releases/download/syslog-ng-$(SYSLOG_NG_VERSION)
SYSLOG_NG_LICENSE = LGPL-2.1+ (syslog-ng core), GPL-2.0+ (modules)
SYSLOG_NG_LICENSE_FILES = COPYING GPL.txt LGPL.txt
SYSLOG_NG_DEPENDENCIES = host-bison host-flex host-pkgconf \
	eventlog libglib2 openssl pcre
# We're patching configure.ac
SYSLOG_NG_AUTORECONF = YES
SYSLOG_NG_CONF_OPTS = --disable-manpages --localstatedir=/var/run \
	--disable-java --disable-java-modules --disable-mongodb

ifeq ($(BR2_PACKAGE_GEOIP),y)
SYSLOG_NG_DEPENDENCIES += geoip
SYSLOG_NG_CONF_OPTS += --enable-geoip
else
SYSLOG_NG_CONF_OPTS += --disable-geoip
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
SYSLOG_NG_DEPENDENCIES += libcap
SYSLOG_NG_CONF_OPTS += --enable-linux-caps
else
SYSLOG_NG_CONF_OPTS += --disable-linux-caps
endif

ifeq ($(BR2_PACKAGE_PYTHON),y)
SYSLOG_NG_DEPENDENCIES += python
SYSLOG_NG_CONF_OPTS += \
	--enable-python \
	--with-python=$(PYTHON_VERSION_MAJOR)
else ifeq ($(BR2_PACKAGE_PYTHON3),y)
SYSLOG_NG_DEPENDENCIES += python3
SYSLOG_NG_CONF_OPTS += \
	--enable-python \
	--with-python=$(PYTHON3_VERSION_MAJOR)
else
SYSLOG_NG_CONF_OPTS += --disable-python
endif

ifeq ($(BR2_PACKAGE_LIBESMTP),y)
SYSLOG_NG_DEPENDENCIES += libesmtp
SYSLOG_NG_CONF_OPTS += --enable-smtp
SYSLOG_NG_CONF_OPTS += --with-libesmtp="$(STAGING_DIR)/usr"
else
SYSLOG_NG_CONF_OPTS += --disable-smtp
endif

ifeq ($(BR2_PACKAGE_JSON_C),y)
SYSLOG_NG_DEPENDENCIES += json-c
SYSLOG_NG_CONF_OPTS += --enable-json
else
SYSLOG_NG_CONF_OPTS += --disable-json
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBUUID),y)
SYSLOG_NG_DEPENDENCIES += util-linux
endif

ifeq ($(BR2_PACKAGE_LIBNET),y)
SYSLOG_NG_DEPENDENCIES += libnet
SYSLOG_NG_CONF_OPTS += \
	--with-libnet=$(STAGING_DIR)/usr/bin \
	--enable-spoof-source
else
SYSLOG_NG_CONF_OPTS += --disable-spoof-source
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
SYSLOG_NG_DEPENDENCIES += libcurl
SYSLOG_NG_CONF_OPTS += --enable-http
SYSLOG_NG_CONF_OPTS += --with-libcurl="$(STAGING_DIR)/usr"
else
SYSLOG_NG_CONF_OPTS += --disable-http
endif

ifeq ($(BR2_PACKAGE_RABBITMQ_C),y)
SYSLOG_NG_DEPENDENCIES += rabbitmq-c
SYSLOG_NG_CONF_OPTS += --enable-amqp
else
SYSLOG_NG_CONF_OPTS += --disable-amqp
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
SYSLOG_NG_DEPENDENCIES += systemd
SYSLOG_NG_CONF_OPTS += \
	--enable-systemd \
	--with-systemdsystemunitdir=/usr/lib/systemd/system
else
SYSLOG_NG_CONF_OPTS += --disable-systemd
endif

define SYSLOG_NG_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/syslog-ng/S01syslog-ng \
		$(TARGET_DIR)/etc/init.d/S01syslog-ng
endef

# By default syslog-ng installs a .service that requires a config file at
# /etc/default, so provide one with the default values.
define SYSLOG_NG_INSTALL_INIT_SYSTEMD
	$(INSTALL) -m 0644 -D package/syslog-ng/syslog-ng@default \
		$(TARGET_DIR)/etc/default/syslog-ng@default
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/syslog-ng@.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/syslog-ng@default.service
endef

# By default syslog-ng installs a number of sample configuration
# files. Some of these rely on optional features being
# enabled. Because of this buildroot uninstalls the shipped config
# files and provides a simplified configuration.
define SYSLOG_NG_FIXUP_CONFIG
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) scl-uninstall-local
	$(INSTALL) -D -m 0644 package/syslog-ng/syslog-ng.conf \
		$(TARGET_DIR)/etc/syslog-ng.conf
endef

SYSLOG_NG_POST_INSTALL_TARGET_HOOKS = SYSLOG_NG_FIXUP_CONFIG

$(eval $(autotools-package))
