################################################################################
#
# libeastl
#
################################################################################

LIBEASTL_VERSION = 45469730d641868ce05433fff2e199510c7d45c3
LIBEASTL_SITE = $(call github,electronicarts,EASTL,$(LIBEASTL_VERSION))
LIBEASTL_LICENSE = BSD-3-Clause
LIBEASTL_LICENSE_FILES = LICENSE
LIBEASTL_INSTALL_STAGING = YES

$(eval $(cmake-package))
