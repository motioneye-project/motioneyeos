################################################################################
#
# libubootenv
#
################################################################################

LIBUBOOTENV_VERSION = 8a7d4030bcb106de11632e85b6a0e7b7d4cb47af
LIBUBOOTENV_SITE = $(call github,sbabic,libubootenv,$(LIBUBOOTENV_VERSION))
LIBUBOOTENV_LICENSE = LGPL-2.1
LIBUBOOTENV_INSTALL_STAGING = YES
LIBUBOOTENV_DEPENDENCIES = zlib

$(eval $(cmake-package))
