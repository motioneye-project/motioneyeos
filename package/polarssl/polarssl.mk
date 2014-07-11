################################################################################
#
# polarssl
#
################################################################################

POLARSSL_SITE = https://polarssl.org/code/releases
POLARSSL_VERSION = 1.2.11
POLARSSL_SOURCE = polarssl-$(POLARSSL_VERSION)-gpl.tgz
POLARSSL_CONF_OPT = \
	-DUSE_SHARED_POLARSSL_LIBRARY=ON \
	-DUSE_STATIC_POLARSSL_LIBRARY=ON \
	-DBUILD_TESTS=OFF \
	-DENABLE_PROGRAMS=$(if $(BR2_PACKAGE_POLARSSL_PROGRAMS),ON,OFF)

POLARSSL_INSTALL_STAGING = YES
POLARSSL_LICENSE = GPLv2
POLARSSL_LICENSE_FILES = LICENSE

$(eval $(cmake-package))
