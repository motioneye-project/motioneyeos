################################################################################
#
# libglu
#
################################################################################

LIBGLU_VERSION = 9.0.0
LIBGLU_SITE = http://cgit.freedesktop.org/mesa/glu/snapshot
LIBGLU_SOURCE = glu-$(LIBGLU_VERSION).tar.gz
LIBGLU_LICENSE = SGI-B-2.0
LIBGLU_LICENSE_FILES = include/GL/glu.h
LIBGLU_INSTALL_STAGING = YES
# upstream does not distribute a autoconf´ed configure script
LIBGLU_AUTORECONF = YES
LIBGLU_DEPENDENCIES = libgl host-pkgconf

$(eval $(autotools-package))
