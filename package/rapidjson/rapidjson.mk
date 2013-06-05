################################################################################
#
# rapidjson
#
################################################################################

RAPIDJSON_VERSION = 0.11
RAPIDJSON_SOURCE = rapidjson-$(RAPIDJSON_VERSION).zip
RAPIDJSON_SITE = http://rapidjson.googlecode.com/files
RAPIDJSON_LICENSE = MIT
RAPIDJSON_LICENSE_FILES = license.txt
RAPIDJSON_INSTALL_TARGET = NO
RAPIDJSON_INSTALL_STAGING = YES

define RAPIDJSON_EXTRACT_CMDS
	unzip -d $(@D) $(DL_DIR)/$(RAPIDJSON_SOURCE)
	mv $(@D)/rapidjson/* $(@D)
	$(RM) -r $(@D)/rapidjson
endef

define RAPIDJSON_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0755 -d $(STAGING_DIR)/usr/include/rapidjson
	$(INSTALL) -m 0755 -d $(STAGING_DIR)/usr/include/rapidjson/internal
	$(INSTALL) -m 0644 $(@D)/include/rapidjson/*.h \
		$(STAGING_DIR)/usr/include/rapidjson
	$(INSTALL) -m 0644 $(@D)/include/rapidjson/internal/*.h \
		$(STAGING_DIR)/usr/include/rapidjson/internal
endef

define RAPIDJSON_UNINSTALL_STAGING_CMDS
	$(RM) -r $(STAGING_DIR)/usr/include/rapidjson
endef

$(eval $(generic-package))
