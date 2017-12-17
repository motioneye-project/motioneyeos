################################################################################
#
# uhttpd
#
################################################################################

UHTTPD_VERSION = a8bf9c00842224edb394e79909053f7628ee6a82
UHTTPD_SITE = http://git.openwrt.org/project/uhttpd.git
UHTTPD_SITE_METHOD = git
UHTTPD_LICENSE = ISC
UHTTPD_LICENSE_FILES = uhttpd.h
UHTTPD_DEPENDENCIES = libubox json-c

ifeq ($(BR2_PACKAGE_LUA_5_1),y)
UHTTPD_DEPENDENCIES += lua
UHTTPD_CONF_OPTS += -DLUA_SUPPORT=ON
else
UHTTPD_CONF_OPTS += -DLUA_SUPPORT=OFF
endif

ifeq ($(BR2_PACKAGE_USTREAM_SSL),y)
UHTTPD_DEPENDENCIES += ustream-ssl
UHTTPD_CONF_OPTS += -DTLS_SUPPORT=ON
else
UHTTPD_CONF_OPTS += -DTLS_SUPPORT=OFF
endif

ifeq ($(BR2_PACKAGE_UBUS),y)
UHTTPD_DEPENDENCIES += ubus
UHTTPD_CONF_OPTS += -DUBUS_SUPPORT=ON
else
UHTTPD_CONF_OPTS += -DUBUS_SUPPORT=OFF
endif

$(eval $(cmake-package))
