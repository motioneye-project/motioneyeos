################################################################################
#
# libuci
#
################################################################################

LIBUCI_VERSION = e339407372ffc70b1451e4eda218c01aa95a6a7f
LIBUCI_SITE = git://nbd.name/uci.git
LIBUCI_LICENSE = LGPLv2.1
LIBUCI_INSTALL_STAGING = YES
LIBUCI_DEPENDENCIES = libubox

ifeq ($(BR2_PACKAGE_LUA_5_1),y)
LIBUCI_DEPENDENCIES += lua
LIBUCI_CONF_OPTS += -DBUILD_LUA=ON \
	-DLUAPATH=$(STAGING_DIR)/usr/lib/lua/5.1 \
	-DLUA_CFLAGS=-I$(STAGING_DIR)/usr/include
else
LIBUCI_CONF_OPTS += -DBUILD_LUA=OFF
endif

$(eval $(cmake-package))
