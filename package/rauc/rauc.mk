################################################################################
#
# rauc
#
################################################################################

RAUC_VERSION = 0.4
RAUC_SITE = https://github.com/rauc/rauc/releases/download/v$(RAUC_VERSION)
RAUC_SOURCE = rauc-$(RAUC_VERSION).tar.xz
RAUC_LICENSE = LGPL-2.1
RAUC_DEPENDENCIES = host-pkgconf openssl libglib2
# 0002-build-make-eMMC-boot-partition-support-optional.patch
RAUC_AUTORECONF = YES

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

HOST_RAUC_DEPENDENCIES = host-pkgconf host-openssl host-libglib2 host-squashfs
HOST_RAUC_CONF_OPTS += --disable-network --disable-json --disable-service

$(eval $(autotools-package))
$(eval $(host-autotools-package))
