################################################################################
#
# libubootenv
#
################################################################################

LIBUBOOTENV_VERSION = ba952d05ec9ab16029816a06d956bac7fb4e9832
LIBUBOOTENV_SITE = $(call github,sbabic,libubootenv,$(LIBUBOOTENV_VERSION))
LIBUBOOTENV_LICENSE = LGPL-2.1
LIBUBOOTENV_LICENSE_FILES = Licenses/lgpl-2.1.txt
LIBUBOOTENV_INSTALL_STAGING = YES
LIBUBOOTENV_DEPENDENCIES = zlib

$(eval $(cmake-package))
