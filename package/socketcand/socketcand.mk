################################################################################
#
# socketcand
#
################################################################################

SOCKETCAND_VERSION = 69e2201222f015a1abe7a58ecf61325012cd91b1
SOCKETCAND_SITE = $(call github,linux-can,socketcand,$(SOCKETCAND_VERSION))
SOCKETCAND_AUTORECONF = YES
SOCKETCAND_LICENSE = BSD-3-Clause or GPL-2.0
SOCKETCAND_LICENSE_FILES = socketcand.c

ifeq ($(BR2_PACKAGE_LIBCONFIG),y)
SOCKETCAND_DEPENDENCIES = libconfig
else
SOCKETCAND_CONF_OPTS = --without-config
endif

$(eval $(autotools-package))
