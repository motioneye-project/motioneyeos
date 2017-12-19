################################################################################
#
# libsilk
#
################################################################################

LIBSILK_VERSION = 4268a02240c35c6055b0f237c46b09b2dcf79e45
# we use the FreeSwitch fork because it contains pkgconf support
LIBSILK_SITE = https://freeswitch.org/stash/scm/sd/libsilk.git
LIBSILK_SITE_METHOD = git
LIBSILK_LICENSE = BSD-3-Clause
LIBSILK_LICENSE_FILES = COPYING
LIBSILK_AUTORECONF = YES
LIBSILK_INSTALL_STAGING = YES

$(eval $(autotools-package))
