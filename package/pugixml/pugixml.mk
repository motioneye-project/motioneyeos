################################################################################
#
# pugixml
#
################################################################################

PUGIXML_VERSION = 1.9
PUGIXML_SITE = http://github.com/zeux/pugixml/releases/download/v$(PUGIXML_VERSION)
PUGIXML_LICENSE = MIT
PUGIXML_LICENSE_FILES = readme.txt
PUGIXML_INSTALL_STAGING = YES

$(eval $(cmake-package))
