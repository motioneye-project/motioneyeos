################################################################################
#
# libubox
#
################################################################################

LIBUBOX_VERSION = 723730214732862de7e892bae2f7a7889e66bf1b
LIBUBOX_SITE = git://git.openwrt.org/project/libubox.git
LIBUBOX_LICENSE = ISC, BSD-3-Clause
LIBUBOX_INSTALL_STAGING = YES
LIBUBOX_DEPENDENCIES = $(if $(BR2_PACKAGE_JSON_C),json-c)

ifeq ($(BR2_USE_MMU)$(BR2_PACKAGE_LUA_5_1),yy)
LIBUBOX_DEPENDENCIES += lua
LIBUBOX_CONF_OPTS += -DBUILD_LUA=ON \
	-DLUAPATH=$(STAGING_DIR)/usr/lib/lua/5.1 \
	-DLUA_CFLAGS=-I$(STAGING_DIR)/usr/include
else
LIBUBOX_CONF_OPTS += -DBUILD_LUA=OFF
endif

$(eval $(cmake-package))
