################################################################################
#
# libebur128
#
################################################################################

LIBEBUR128_VERSION = v1.1.0
LIBEBUR128_SITE = $(call github,jiixyj,libebur128,$(LIBEBUR128_VERSION))
LIBEBUR128_LICENSE = MIT
LIBEBUR128_LICENSE_FILES = COPYING
LIBEBUR128_INSTALL_STAGING = YES
LIBEBUR128_DEPENDENCIES = speex

$(eval $(cmake-package))
