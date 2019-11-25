################################################################################
#
# libubootenv
#
################################################################################

LIBUBOOTENV_VERSION = 92949816720d7af2ac722016e7a5b9a85ff141bc
LIBUBOOTENV_SITE = $(call github,sbabic,libubootenv,$(LIBUBOOTENV_VERSION))
LIBUBOOTENV_LICENSE = LGPL-2.1
LIBUBOOTENV_LICENSE_FILES = Licenses/lgpl-2.1.txt
LIBUBOOTENV_INSTALL_STAGING = YES
LIBUBOOTENV_DEPENDENCIES = zlib

$(eval $(cmake-package))
