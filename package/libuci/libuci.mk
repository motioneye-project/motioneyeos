################################################################################
#
# libuci
#
################################################################################

LIBUCI_VERSION = 262fede3e8c8c08c1eb0d1be9bf102232fb86cb9
LIBUCI_SITE = git://nbd.name/uci.git
LIBUCI_LICENSE = LGPLv2.1
LIBUCI_INSTALL_STAGING = YES
LIBUCI_DEPENDENCIES = libubox

ifeq ($(BR2_PACKAGE_LUA),y)
	LIBUCI_DEPENDENCIES += lua
else
	LIBUCI_CONF_OPT += -DBUILD_LUA:BOOL=OFF
endif

$(eval $(cmake-package))
