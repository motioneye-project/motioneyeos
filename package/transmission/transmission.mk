################################################################################
#
# transmission
#
################################################################################

TRANSMISSION_VERSION = 2.84
TRANSMISSION_SITE = http://download.transmissionbt.com/files/
TRANSMISSION_SOURCE = transmission-$(TRANSMISSION_VERSION).tar.xz
TRANSMISSION_DEPENDENCIES = \
	host-pkgconf \
	host-intltool \
	libcurl \
	libevent \
	openssl \
	zlib
TRANSMISSION_AUTORECONF = YES
TRANSMISSION_CONF_OPT = \
	--disable-libnotify \
	--enable-lightweight
TRANSMISSION_LICENSE = GPLv2 or GPLv3 with OpenSSL exception
TRANSMISSION_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_TRANSMISSION_UTP),y)
	TRANSMISSION_CONF_OPT += --enable-utp
else
	TRANSMISSION_CONF_OPT += --disable-utp
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_CLI),y)
	TRANSMISSION_CONF_OPT += --enable-cli
else
	TRANSMISSION_CONF_OPT += --disable-cli
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_DAEMON),y)
	TRANSMISSION_CONF_OPT += --enable-daemon

define TRANSMISSION_INSTALL_INIT_SYSV
	[ -f $(TARGET_DIR)/etc/init.d/S92transmission ] || \
		$(INSTALL) -m 0755 -D package/transmission/S92transmission \
			$(TARGET_DIR)/etc/init.d/S92transmission
endef

else
	TRANSMISSION_CONF_OPT += --disable-daemon
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_REMOTE),y)
	TRANSMISSION_CONF_OPT += --enable-remote
else
	TRANSMISSION_CONF_OPT += --disable-remote
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_GTK),y)
	TRANSMISSION_CONF_OPT += --enable-gtk
	TRANSMISSION_DEPENDENCIES += libgtk2
else
	TRANSMISSION_CONF_OPT += --disable-gtk
endif

$(eval $(autotools-package))
