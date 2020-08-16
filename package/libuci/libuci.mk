################################################################################
#
# libuci
#
################################################################################

LIBUCI_VERSION = 49ec6efbdac4819033d34f08927d795f83a3932d
LIBUCI_SITE = git://git.openwrt.org/project/uci.git
LIBUCI_LICENSE = LGPL-2.1, GPL-2.0 (tools)
LIBUCI_INSTALL_STAGING = YES
LIBUCI_DEPENDENCIES = libubox

ifeq ($(BR2_PACKAGE_LUA_5_1),y)
LIBUCI_DEPENDENCIES += lua
LIBUCI_CONF_OPTS += -DBUILD_LUA=ON \
	-DLUAPATH=/usr/lib/lua/5.1 \
	-DLUA_CFLAGS=-I$(STAGING_DIR)/usr/include
LIBUCI_LICENSE += , GPL-2.0 (lua bindings)
else
LIBUCI_CONF_OPTS += -DBUILD_LUA=OFF
endif

$(eval $(cmake-package))
