################################################################################
#
# libubootenv
#
################################################################################

LIBUBOOTENV_VERSION = 879c0731fa0725785b9fa4499bbf6aacd04ee4c2
LIBUBOOTENV_SITE = $(call github,sbabic,libubootenv,$(LIBUBOOTENV_VERSION))
LIBUBOOTENV_LICENSE = LGPL-2.1
LIBUBOOTENV_LICENSE_FILES = Licenses/lgpl-2.1.txt
LIBUBOOTENV_INSTALL_STAGING = YES
LIBUBOOTENV_DEPENDENCIES = zlib

$(eval $(cmake-package))
