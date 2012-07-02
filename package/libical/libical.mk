#############################################################
#
# libical
#
#############################################################

LIBICAL_VERSION = 0.48
LIBICAL_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/project/freeassociation/libical/libical-$(LIBICAL_VERSION)
LIBICAL_INSTALL_STAGING = YES

$(eval $(autotools-package))

