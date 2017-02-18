################################################################################
#
# socketcand
#
################################################################################

SOCKETCAND_VERSION = 8339e62a6bf60be571672678fb1de544768cf40e
SOCKETCAND_SITE = $(call github,dschanoeh,socketcand,$(SOCKETCAND_VERSION))
SOCKETCAND_AUTORECONF = YES
SOCKETCAND_LICENSE = BSD-3c or GPLv2
SOCKETCAND_LICENSE_FILES = socketcand.c

ifeq ($(BR2_PACKAGE_LIBCONFIG),y)
SOCKETCAND_DEPENDENCIES = libconfig
else
SOCKETCAND_CONF_OPTS = --without-config
endif

$(eval $(autotools-package))
