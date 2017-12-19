################################################################################
#
# pdmenu
#
################################################################################

PDMENU_VERSION = 1.3.4
PDMENU_SOURCE = pdmenu_$(PDMENU_VERSION).tar.gz
PDMENU_SITE = http://snapshot.debian.org/archive/debian/20170828T160058Z/pool/main/p/pdmenu
PDMENU_LICENSE = GPL-2.0
PDMENU_LICENSE_FILES = doc/COPYING
PDMENU_DEPENDENCIES = slang $(TARGET_NLS_DEPENDENCIES)
PDMENU_INSTALL_TARGET_OPTS = INSTALL_PREFIX=$(TARGET_DIR) install

$(eval $(autotools-package))
