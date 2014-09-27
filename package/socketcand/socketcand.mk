################################################################################
#
# socketcand
#
################################################################################

SOCKETCAND_VERSION = 274e4e44107f6138a29bbc4e20f9fbd2a7d4dab1
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
