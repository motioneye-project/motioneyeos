################################################################################
#
# fastd
#
################################################################################

FASTD_VERSION = v17
FASTD_SITE = git://git.universe-factory.net/fastd
FASTD_LICENSE = BSD-2c
FASTD_LICENSE_FILES = COPYRIGHT
FASTD_CONF_OPTS = -DENABLE_LIBSODIUM=ON
FASTD_DEPENDENCIES = host-bison host-pkgconf libuecc libsodium libcap

ifeq ($(BR2_PACKAGE_OPENSSL),y)
FASTD_CONF_OPTS += -DENABLE_OPENSSL=ON
FASTD_DEPENDENCIES += openssl
else
FASTD_CONF_OPTS += -DENABLE_OPENSSL=OFF
endif

ifeq ($(BR2_PACKAGE_FASTD_STATUS_SOCKET),y)
FASTD_CONF_OPTS += -DWITH_STATUS_SOCKET=ON
FASTD_DEPENDENCIES += json-c
else
FASTD_CONF_OPTS += -DWITH_STATUS_SOCKET=OFF
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
FASTD_CONF_OPTS += -DENABLE_SYSTEMD=ON
else
FASTD_CONF_OPTS += -DENABLE_SYSTEMD=OFF
endif

ifeq ($(BR2_GCC_ENABLE_LTO),y)
FASTD_CONF_OPTS += -DENABLE_LTO=ON
else
FASTD_CONF_OPTS += -DENABLE_LTO=OFF
endif

$(eval $(cmake-package))
