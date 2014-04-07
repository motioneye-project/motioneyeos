################################################################################
#
# libubox
#
################################################################################

LIBUBOX_VERSION = bbd846ec2d72b2629758b69dc122ac0b0f2c3e4b
LIBUBOX_SITE = git://nbd.name/luci2/libubox.git
LIBUBOX_LICENSE = LGPLv2.1, GPLv2, BSD-3c, MIT
LIBUBOX_INSTALL_STAGING = YES
LIBUBOX_DEPENDENCIES = host-pkgconf $(if $(BR2_PACKAGE_JSON_C),json-c)

ifeq ($(BR2_USE_MMU)$(BR2_PACKAGE_LUA_5_1),yy)
LIBUBOX_DEPENDENCIES += lua
LIBUBOX_CONF_OPT += -DLUAPATH=$(STAGING_DIR)/usr/lib/lua/5.1 \
	-DLUA_CFLAGS=-I$(STAGING_DIR)/usr/include
else
LIBUBOX_CONF_OPT += -DBUILD_LUA:BOOL=OFF
endif

$(eval $(cmake-package))
