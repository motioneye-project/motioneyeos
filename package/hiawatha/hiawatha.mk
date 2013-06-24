################################################################################
#
# hiawatha
#
################################################################################

HIAWATHA_VERSION = 9.2
HIAWATHA_SITE = http://www.hiawatha-webserver.org/files
HIAWATHA_LICENSE = GPLv2
HIAWATHA_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_HIAWATHA_SSL),y)
HIAWATHA_CONF_OPT += -DUSE_SYSTEM_POLARSSL=ON
HIAWATHA_DEPENDENCIES += polarssl
else
HIAWATHA_CONF_OPT += -DENABLE_SSL=OFF
endif

HIAWATHA_CONF_OPT += \
	$(if $(BR2_INET_IPV6),,-DENABLE_IPV6=OFF) \
	-DENABLE_TOOLKIT=OFF \
	-DENABLE_XSLT=OFF \
	-DCONFIG_DIR=/etc/hiawatha \
	-DLOG_DIR=/var/log \
	-DPID_DIR=/var/run \
	-DWEBROOT_DIR=/var/www/hiawatha \
	-DWORK_DIR=/var/lib/hiawatha

$(eval $(cmake-package))
