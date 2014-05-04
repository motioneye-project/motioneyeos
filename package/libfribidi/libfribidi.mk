################################################################################
#
# libfribidi
#
################################################################################

LIBFRIBIDI_VERSION = 0.19.6
LIBFRIBIDI_SOURCE = fribidi-$(LIBFRIBIDI_VERSION).tar.bz2
LIBFRIBIDI_SITE = http://www.fribidi.org/download/
LIBFRIBIDI_LICENSE = LGPLv2.1+
LIBFRIBIDI_LICENSE_FILES = COPYING
LIBFRIBIDI_INSTALL_STAGING = YES
# BR's libtool patch doesn't apply
LIBFRIBIDI_AUTORECONF = YES

$(eval $(autotools-package))
