################################################################################
#
# ympd
#
################################################################################

YMPD_VERSION = 1.3.0
YMPD_SITE = $(call github,notandy,ympd,v$(YMPD_VERSION))
YMPD_LICENSE = GPL-2.0
YMPD_LICENSE_FILES = LICENSE
YMPD_DEPENDENCIES = libmpdclient

ifeq ($(BR2_PACKAGE_OPENSSL),y)
YMPD_DEPENDENCIES += openssl
YMPD_CONF_OPTS += -DWITH_SSL=ON
else
YMPD_CONF_OPTS += -DWITH_SSL=OFF
endif

$(eval $(cmake-package))
