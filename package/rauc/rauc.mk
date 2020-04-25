################################################################################
#
# rauc
#
################################################################################

RAUC_VERSION = 1.3
RAUC_SITE = https://github.com/rauc/rauc/releases/download/v$(RAUC_VERSION)
RAUC_SOURCE = rauc-$(RAUC_VERSION).tar.xz
RAUC_LICENSE = LGPL-2.1
RAUC_LICENSE_FILES = COPYING
RAUC_DEPENDENCIES = host-pkgconf openssl libglib2 dbus

ifeq ($(BR2_PACKAGE_RAUC_NETWORK),y)
RAUC_CONF_OPTS += --enable-network
RAUC_DEPENDENCIES += libcurl
else
RAUC_CONF_OPTS += --disable-network
endif

ifeq ($(BR2_PACKAGE_RAUC_JSON),y)
RAUC_CONF_OPTS += --enable-json
RAUC_DEPENDENCIES += json-glib
else
RAUC_CONF_OPTS += --disable-json
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
# configure uses pkg-config --variable=systemdsystemunitdir systemd
RAUC_DEPENDENCIES += systemd
endif

define RAUC_INSTALL_INIT_SYSTEMD
	mkdir $(TARGET_DIR)/usr/lib/systemd/system/rauc.service.d
	printf '[Install]\nWantedBy=multi-user.target\n' \
		>$(TARGET_DIR)/usr/lib/systemd/system/rauc.service.d/buildroot-enable.conf
endef

HOST_RAUC_DEPENDENCIES = \
	host-pkgconf \
	host-openssl \
	host-libglib2 \
	host-squashfs \
	$(if $(BR2_PACKAGE_HOST_LIBP11),host-libp11)
HOST_RAUC_CONF_OPTS += \
	--disable-network \
	--disable-json \
	--disable-service \
	--without-dbuspolicydir

$(eval $(autotools-package))
$(eval $(host-autotools-package))
