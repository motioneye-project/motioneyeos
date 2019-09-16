################################################################################
#
# mxml
#
################################################################################

MXML_VERSION = 3.1
MXML_SITE = https://github.com/michaelrsweet/mxml/releases/download/v$(MXML_VERSION)
MXML_LICENSE = Apache-2.0 with exceptions
MXML_LICENSE_FILES = LICENSE NOTICE
MXML_INSTALL_STAGING = YES

MXML_INSTALL_STAGING_OPTS = DSTROOT=$(STAGING_DIR) install
MXML_INSTALL_TARGET_OPTS = DSTROOT=$(TARGET_DIR) install

$(eval $(autotools-package))
