################################################################################
#
# libfribidi
#
################################################################################

LIBFRIBIDI_VERSION = 0.19.5
LIBFRIBIDI_SOURCE = fribidi-$(LIBFRIBIDI_VERSION).tar.bz2
LIBFRIBIDI_SITE = http://www.fribidi.org/download/
LIBFRIBIDI_LICENSE = LGPLv2.1+
LIBFRIBIDI_LICENSE_FILES = COPYING
LIBFRIBIDI_INSTALL_STAGING = YES

$(eval $(autotools-package))
