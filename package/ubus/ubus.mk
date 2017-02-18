################################################################################
#
# ubus
#
################################################################################

UBUS_VERSION = 259450f414d8c9ee41896e8e6d6bc57ec00e2b63
UBUS_SITE = git://git.openwrt.org/project/ubus.git

UBUS_LICENSE = LGPLv2.1
UBUS_LICENSE_FILES = ubusd_acl.h

UBUS_INSTALL_STAGING = YES

UBUS_DEPENDENCIES = json-c libubox

# package only compiles with Lua 5.1
ifeq ($(BR2_PACKAGE_LUA_5_1),y)
UBUS_DEPENDENCIES += lua
UBUS_CONF_OPTS += -DBUILD_LUA=ON \
	-DLUA_CFLAGS=-I$(STAGING_DIR)/usr/include \
	-DLUAPATH=/usr/lib/lua/$(LUAINTERPRETER_ABIVER)
else
UBUS_CONF_OPTS += -DBUILD_LUA=OFF
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
UBUS_DEPENDENCIES += systemd
UBUS_CONF_OPTS += -DENABLE_SYSTEMD=ON
else
UBUS_CONF_OPTS += -DENABLE_SYSTEMD=OFF
endif

ifeq ($(BR2_PACKAGE_UBUS_EXAMPLES),y)
UBUS_CONF_OPTS += -DBUILD_EXAMPLES=ON
else
UBUS_CONF_OPTS += -DBUILD_EXAMPLES=OFF
endif

$(eval $(cmake-package))
