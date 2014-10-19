################################################################################
#
# libubox
#
################################################################################

LIBUBOX_VERSION = 5a0bbefc8fa440446253b171d0ac038d839360e3
LIBUBOX_SITE = git://nbd.name/luci2/libubox.git
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
