################################################################################
#
# libfribidi
#
################################################################################

LIBFRIBIDI_VERSION = 1.0.7
LIBFRIBIDI_SOURCE = fribidi-$(LIBFRIBIDI_VERSION).tar.bz2
LIBFRIBIDI_SITE = https://github.com/fribidi/fribidi/releases/download/v$(LIBFRIBIDI_VERSION)
LIBFRIBIDI_LICENSE = LGPL-2.1+
LIBFRIBIDI_LICENSE_FILES = COPYING
LIBFRIBIDI_INSTALL_STAGING = YES
LIBFRIBIDI_DEPENDENCIES = host-pkgconf

$(eval $(autotools-package))
$(eval $(host-autotools-package))
