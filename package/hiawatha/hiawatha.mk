HIAWATHA_VERSION = 8.6
HIAWATHA_SITE = http://www.hiawatha-webserver.org/files
HIAWATHA_LICENSE = GPLv2
HIAWATHA_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_HIAWATHA_SSL),y)
HIAWATHA_CONF_OPT += -DENABLE_SSL_EXTERNAL=ON -DENABLE_SSL=ON
HIAWATHA_DEPENDENCIES += polarssl
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
