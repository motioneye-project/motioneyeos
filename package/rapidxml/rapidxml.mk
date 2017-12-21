################################################################################
#
# rapidxml
#
################################################################################

RAPIDXML_VERSION = 1.13
RAPIDXML_SOURCE = rapidxml-$(RAPIDXML_VERSION).zip
RAPIDXML_SITE = http://downloads.sourceforge.net/project/rapidxml/rapidxml/rapidxml%20$(RAPIDXML_VERSION)
RAPIDXML_LICENSE = BSL-1.0 or MIT
RAPIDXML_LICENSE_FILES = license.txt

# C++ headers only
RAPIDXML_INSTALL_TARGET = NO
RAPIDXML_INSTALL_STAGING = YES

define RAPIDXML_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(DL_DIR)/$(RAPIDXML_SOURCE)
	mv $(@D)/rapidxml-$(RAPIDXML_VERSION)/* $(@D)/
	rmdir $(@D)/rapidxml-$(RAPIDXML_VERSION)
endef

define RAPIDXML_INSTALL_STAGING_CMDS
	cp -dpfr $(@D)/*hpp $(STAGING_DIR)/usr/include
endef

$(eval $(generic-package))
