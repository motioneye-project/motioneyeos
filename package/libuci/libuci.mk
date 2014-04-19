################################################################################
#
# libuci
#
################################################################################

LIBUCI_VERSION = ed938cc8e423d4a33b8f31e6e6d1eb0805ae3d10
LIBUCI_SITE = git://nbd.name/uci.git
LIBUCI_LICENSE = LGPLv2.1
LIBUCI_INSTALL_STAGING = YES
LIBUCI_DEPENDENCIES = libubox

ifeq ($(BR2_PACKAGE_LUA_5_1),y)
LIBUCI_DEPENDENCIES += lua
LIBUCI_CONF_OPT += -DLUAPATH=$(STAGING_DIR)/usr/lib/lua/5.1 \
	-DLUA_CFLAGS=-I$(STAGING_DIR)/usr/include
else
LIBUCI_CONF_OPT += -DBUILD_LUA:BOOL=OFF
endif

$(eval $(cmake-package))
