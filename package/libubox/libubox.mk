################################################################################
#
# libubox
#
################################################################################

LIBUBOX_VERSION = e88d816d6e462180f0337565e04e36be58a63309
LIBUBOX_SITE = git://git.openwrt.org/project/libubox.git
LIBUBOX_LICENSE = LGPLv2.1, GPLv2, BSD-3c, MIT
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
