################################################################################
#
# transmission
#
################################################################################

TRANSMISSION_VERSION = 2.92
TRANSMISSION_SITE = https://github.com/transmission/transmission-releases/raw/master
TRANSMISSION_SOURCE = transmission-$(TRANSMISSION_VERSION).tar.xz
TRANSMISSION_DEPENDENCIES = \
	host-pkgconf \
	host-intltool \
	libcurl \
	libevent \
	openssl \
	zlib
TRANSMISSION_AUTORECONF = YES
TRANSMISSION_CONF_OPTS = \
	--disable-libnotify \
	--enable-lightweight
TRANSMISSION_LICENSE = GPL-2.0 or GPL-3.0 with OpenSSL exception
TRANSMISSION_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBMINIUPNPC),y)
TRANSMISSION_DEPENDENCIES += libminiupnpc
endif

ifeq ($(BR2_PACKAGE_LIBNATPMP),y)
TRANSMISSION_DEPENDENCIES += libnatpmp
TRANSMISSION_CONF_OPTS += --enable-external-natpmp
else
TRANSMISSION_CONF_OPTS += --disable-external-natpmp
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_UTP),y)
TRANSMISSION_CONF_OPTS += --enable-utp
else
TRANSMISSION_CONF_OPTS += --disable-utp
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_CLI),y)
TRANSMISSION_CONF_OPTS += --enable-cli
else
TRANSMISSION_CONF_OPTS += --disable-cli
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_DAEMON),y)
TRANSMISSION_CONF_OPTS += --enable-daemon

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
TRANSMISSION_DEPENDENCIES += systemd
TRANSMISSION_CONF_OPTS += --with-systemd-daemon
else
TRANSMISSION_CONF_OPTS += --without-systemd-daemon
endif

define TRANSMISSION_USERS
	transmission -1 transmission -1 * /var/lib/transmission - transmission Transmission Daemon
endef

define TRANSMISSION_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/transmission/S92transmission \
		$(TARGET_DIR)/etc/init.d/S92transmission
endef

define TRANSMISSION_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0755 $(@D)/daemon/transmission-daemon.service \
		$(TARGET_DIR)/usr/lib/systemd/system/transmission-daemon.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/transmission-daemon.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/transmission-daemon.service
endef

else
TRANSMISSION_CONF_OPTS += --disable-daemon
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_REMOTE),y)
TRANSMISSION_CONF_OPTS += --enable-remote
else
TRANSMISSION_CONF_OPTS += --disable-remote
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_GTK),y)
TRANSMISSION_CONF_OPTS += --enable-gtk
TRANSMISSION_DEPENDENCIES += libgtk2
else
TRANSMISSION_CONF_OPTS += --disable-gtk
endif

$(eval $(autotools-package))
