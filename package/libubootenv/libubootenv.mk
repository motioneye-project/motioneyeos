################################################################################
#
# libubootenv
#
################################################################################

LIBUBOOTENV_VERSION = f4b9cde3815abe84a98079cedd515283ea08c16b
LIBUBOOTENV_SITE = $(call github,sbabic,libubootenv,$(LIBUBOOTENV_VERSION))
LIBUBOOTENV_LICENSE = LGPL-2.1
LIBUBOOTENV_LICENSE_FILES = Licenses/lgpl-2.1.txt
LIBUBOOTENV_INSTALL_STAGING = YES
LIBUBOOTENV_DEPENDENCIES = zlib

$(eval $(cmake-package))
