#############################################################
#
# mxml
#
#############################################################
MXML_VERSION = 2.7
MXML_SITE = http://ftp.easysw.com/pub/mxml/$(MXML_VERSION)
MXML_LICENSE = LGPLv2+ with exceptions
MXML_LICENSE_FILES = COPYING
MXML_INSTALL_STAGING = YES

MXML_INSTALL_STAGING_OPT = DSTROOT=$(STAGING_DIR) install
MXML_INSTALL_TARGET_OPT = DSTROOT=$(TARGET_DIR) install
MXML_UNINSTALL_STAGING_OPT = DSTROOT=$(STAGING_DIR) uninstall
MXML_UNINSTALL_TARGET_OPT = DSTROOT=$(TARGET_DIR) uninstall

$(eval $(autotools-package))
