#############################################################
#
# mxml
#
#############################################################
MXML_VERSION = 2.6
MXML_SITE = http://ftp.easysw.com/pub/mxml/2.6
MXML_INSTALL_STAGING = YES

MXML_INSTALL_STAGING_OPT = DSTROOT=$(TARGET_DIR) install
MXML_INSTALL_TARGET_OPT = DSTROOT=$(TARGET_DIR) install
MXML_UNINSTALL_STAGING_OPT = DSTROOT=$(TARGET_DIR) uninstall
MXML_UNINSTALL_TARGET_OPT = DSTROOT=$(TARGET_DIR) uninstall

$(eval $(call AUTOTARGETS,package,mxml))
