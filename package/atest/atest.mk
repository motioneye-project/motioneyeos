################################################################################
#
# atest
#
################################################################################

ATEST_VERSION = 895b0183a89c15f5e2305a6795bb1667753cd3f0
ATEST_SITE = $(call github,amouiche,atest,$(ATEST_VERSION))
ATEST_LICENSE = GPL-2.0+
ATEST_LICENSE_FILES = COPYING
ATEST_DEPENDENCIES = host-pkgconf libev alsa-lib
# Fetched from Github, with no configure script
ATEST_AUTORECONF = YES

$(eval $(autotools-package))
