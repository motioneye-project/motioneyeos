################################################################################
#
# libsidplay2
#
################################################################################

LIBSIDPLAY2_VERSION = 2.1.1
LIBSIDPLAY2_SOURCE = sidplay-libs-$(LIBSIDPLAY2_VERSION).tar.gz
LIBSIDPLAY2_SITE = http://downloads.sourceforge.net/project/sidplay2/sidplay2/sidplay-libs-$(LIBSIDPLAY2_VERSION)
LIBSIDPLAY2_LICENSE = GPLv2+
LIBSIDPLAY2_LICENSE_FILES = libsidplay/COPYING
LIBSIDPLAY2_AUTORECONF = YES
LIBSIDPLAY2_INSTALL_STAGING = YES

$(eval $(autotools-package))
