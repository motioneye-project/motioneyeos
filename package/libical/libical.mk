################################################################################
#
# libical
#
################################################################################

LIBICAL_VERSION = 0.48
LIBICAL_SITE = http://downloads.sourceforge.net/project/freeassociation/libical/libical-$(LIBICAL_VERSION)
LIBICAL_INSTALL_STAGING = YES

$(eval $(autotools-package))
