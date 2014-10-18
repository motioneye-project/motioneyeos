################################################################################
#
# libpciaccess
#
################################################################################

LIBPCIACCESS_VERSION = 0.13.2
LIBPCIACCESS_SOURCE = libpciaccess-$(LIBPCIACCESS_VERSION).tar.bz2
LIBPCIACCESS_SITE = http://xorg.freedesktop.org/releases/individual/lib
LIBPCIACCESS_LICENSE = MIT
LIBPCIACCESS_LICENSE_FILES = COPYING
LIBPCIACCESS_INSTALL_STAGING = YES

$(eval $(autotools-package))
