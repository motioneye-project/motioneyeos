################################################################################
#
# libical
#
################################################################################

LIBICAL_VERSION = 0.48
LIBICAL_SITE = http://downloads.sourceforge.net/project/freeassociation/libical/libical-$(LIBICAL_VERSION)
LIBICAL_INSTALL_STAGING = YES
LIBICAL_LICENSE = MPLv1.0 or LGPLv2.1
LIBICAL_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
