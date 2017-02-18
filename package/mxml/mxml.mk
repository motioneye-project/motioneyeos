################################################################################
#
# mxml
#
################################################################################

MXML_VERSION = 2.9
MXML_SITE = http://www.msweet.org/files/project3
MXML_LICENSE = LGPLv2+ with exceptions
MXML_LICENSE_FILES = COPYING
MXML_INSTALL_STAGING = YES

MXML_INSTALL_STAGING_OPTS = DSTROOT=$(STAGING_DIR) install
MXML_INSTALL_TARGET_OPTS = DSTROOT=$(TARGET_DIR) install

$(eval $(autotools-package))
