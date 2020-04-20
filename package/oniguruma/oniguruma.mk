################################################################################
#
# oniguruma
#
################################################################################

ONIGURUMA_VERSION = 6.9.5
ONIGURUMA_SITE = \
	https://github.com/kkos/oniguruma/releases/download/v$(ONIGURUMA_VERSION)
ONIGURUMA_SOURCE = onig-$(ONIGURUMA_VERSION).tar.gz
ONIGURUMA_LICENSE = BSD-2-Clause
ONIGURUMA_LICENSE_FILES = COPYING
ONIGURUMA_INSTALL_STAGING = YES

$(eval $(autotools-package))
