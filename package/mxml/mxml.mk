################################################################################
#
# mxml
#
################################################################################

MXML_VERSION = 2.8
MXML_SITE = http://www.msweet.org/files/project3
MXML_LICENSE = LGPLv2+ with exceptions
MXML_LICENSE_FILES = COPYING
MXML_INSTALL_STAGING = YES

MXML_INSTALL_STAGING_OPT = DSTROOT=$(STAGING_DIR) install
MXML_INSTALL_TARGET_OPT = DSTROOT=$(TARGET_DIR) install

$(eval $(autotools-package))
