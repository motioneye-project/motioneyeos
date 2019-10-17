################################################################################
#
# glorytun
#
################################################################################

GLORYTUN_VERSION = 0.2.2
GLORYTUN_SITE = https://github.com/angt/glorytun/releases/download/v$(GLORYTUN_VERSION)
GLORYTUN_DEPENDENCIES = libsodium host-pkgconf
GLORYTUN_LICENSE = BSD-2-clause
GLORYTUN_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
