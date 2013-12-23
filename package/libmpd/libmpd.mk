################################################################################
#
# libmpd
#
################################################################################

LIBMPD_VERSION_MAJOR = 11.8
LIBMPD_VERSION = $(LIBMPD_VERSION_MAJOR).17
LIBMPD_SITE = http://download.sarine.nl/Programs/gmpc/$(LIBMPD_VERSION_MAJOR)
LIBMPD_INSTALL_STAGING = YES
LIBMPD_DEPENDENCIES = libglib2
LIBMPD_LICENSE = GPLv2+
LIBMPD_LICENSE_FILES = COPYING

$(eval $(autotools-package))
