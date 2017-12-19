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

# Autoreconf requires an existing m4 directory
define ATEST_PATCH_M4
	mkdir -p $(@D)/m4
endef
ATEST_POST_PATCH_HOOKS += ATEST_PATCH_M4

$(eval $(autotools-package))
