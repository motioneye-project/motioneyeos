################################################################################
#
# libcorrect
#
################################################################################

LIBCORRECT_VERSION = ce6c17f1f988765ae3695315d7cce1f2a2e6cf0d
LIBCORRECT_SITE = $(call github,quiet,libcorrect,$(LIBCORRECT_VERSION))
LIBCORRECT_LICENSE = BSD-3-Clause
LIBCORRECT_LICENSE_FILES = LICENSE
LIBCORRECT_INSTALL_STAGING = YES

$(eval $(cmake-package))
