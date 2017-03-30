################################################################################
#
# socketcand
#
################################################################################

SOCKETCAND_VERSION = df7fb4ff8a4439d7737fe2df3540e1ab7465721a
SOCKETCAND_SITE = $(call github,dschanoeh,socketcand,$(SOCKETCAND_VERSION))
SOCKETCAND_AUTORECONF = YES
SOCKETCAND_LICENSE = BSD-3-Clause or GPL-2.0
SOCKETCAND_LICENSE_FILES = socketcand.c

ifeq ($(BR2_PACKAGE_LIBCONFIG),y)
SOCKETCAND_DEPENDENCIES = libconfig
else
SOCKETCAND_CONF_OPTS = --without-config
endif

$(eval $(autotools-package))
