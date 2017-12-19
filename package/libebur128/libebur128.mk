################################################################################
#
# libebur128
#
################################################################################

LIBEBUR128_VERSION = v1.2.2
LIBEBUR128_SITE = $(call github,jiixyj,libebur128,$(LIBEBUR128_VERSION))
LIBEBUR128_LICENSE = MIT
LIBEBUR128_LICENSE_FILES = COPYING
LIBEBUR128_INSTALL_STAGING = YES

$(eval $(cmake-package))
