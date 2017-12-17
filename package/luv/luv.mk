################################################################################
#
# luv
#
################################################################################

LUV_VERSION = 1.9.1-1
LUV_SITE = https://github.com/luvit/luv/releases/download/$(LUV_VERSION)
LUV_LICENSE = Apache-2.0
LUV_LICENSE_FILES = LICENSE.txt
LUV_DEPENDENCIES = libuv
LUV_INSTALL_STAGING = YES

LUV_CONF_OPTS += \
	-DBUILD_MODULE=OFF \
	-DWITH_SHARED_LIBUV=ON \
	-DLUA_BUILD_TYPE=System

ifeq ($(BR2_PACKAGE_LUAJIT),y)
LUV_DEPENDENCIES += luajit
LUV_CONF_OPTS += \
	-DWITH_LUA_ENGINE=LuaJIT
else
LUV_DEPENDENCIES += lua
LUV_CONF_OPTS += \
	-DWITH_LUA_ENGINE=Lua
endif

$(eval $(cmake-package))
