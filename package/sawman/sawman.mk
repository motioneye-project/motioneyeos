################################################################################
#
# sawman
#
################################################################################

SAWMAN_VERSION = 1.6.3
SAWMAN_SOURCE = SaWMan-$(SAWMAN_VERSION).tar.gz
SAWMAN_SITE = http://www.directfb.org/downloads/Extras
SAWMAN_INSTALL_STAGING = YES
SAWMAN_AUTORECONF = YES
SAWMAN_DEPENDENCIES = directfb

$(eval $(autotools-package))
