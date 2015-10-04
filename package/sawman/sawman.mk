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
SAWMAN_LICENSE = LGPLv2.1+
SAWMAN_LICENSE_FILES = COPYING

$(eval $(autotools-package))
