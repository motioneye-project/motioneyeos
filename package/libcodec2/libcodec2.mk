################################################################################
#
# libcodec2
#
################################################################################

LIBCODEC2_VERSION = 392a55b4f3f8ad30d845ac6ae35e8b27343bb944
LIBCODEC2_SITE = https://freeswitch.org/stash/scm/sd/libcodec2.git
LIBCODEC2_SITE_METHOD = git
LIBCODEC2_LICENSE = LGPL-2.1
LIBCODEC2_LICENSE_FILES = COPYING
LIBCODEC2_AUTORECONF = YES
LIBCODEC2_INSTALL_STAGING = YES
LIBCODEC2_CONF_OPTS = --disable-unittests

$(eval $(autotools-package))
