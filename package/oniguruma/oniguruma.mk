################################################################################
#
# oniguruma
#
################################################################################

ONIGURUMA_VERSION = 6.9.3
ONIGURUMA_SITE = $(call github,kkos,oniguruma,v$(ONIGURUMA_VERSION))
ONIGURUMA_LICENSE = BSD-2-Clause
ONIGURUMA_LICENSE_FILES = COPYING
# From git
ONIGURUMA_AUTORECONF = YES
ONIGURUMA_INSTALL_STAGING = YES

$(eval $(autotools-package))
