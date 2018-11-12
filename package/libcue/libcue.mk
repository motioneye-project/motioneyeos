################################################################################
#
# libcue
#
################################################################################

LIBCUE_VERSION = v2.2.1
LIBCUE_SITE = $(call github,lipnitsk,libcue,$(LIBCUE_VERSION))
LIBCUE_LICENSE = GPL-2.0, BSD-2-Clause (rem.c)
LIBCUE_LICENSE_FILES = LICENSE
LIBCUE_DEPENDENCIES = host-bison host-flex flex
LIBCUE_INSTALL_STAGING = YES

$(eval $(cmake-package))
