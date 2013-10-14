################################################################################
#
# libcue
#
################################################################################

LIBCUE_VERSION = 1.4.0
LIBCUE_SITE = http://downloads.sourceforge.net/project/libcue/libcue/$(LIBCUE_VERSION)
LIBCUE_SOURCE = libcue-$(LIBCUE_VERSION).tar.bz2
LIBCUE_LICENSE = GPLv2, BSD-2c (rem.c)
LIBCUE_LICENSE_FILES = COPYING
LIBCUE_DEPENDENCIES = flex
LIBCUE_INSTALL_STAGING = YES

$(eval $(autotools-package))
