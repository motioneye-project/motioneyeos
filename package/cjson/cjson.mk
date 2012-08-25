#############################################################
#
# cjson
#
#############################################################
CJSON_VERSION         = undefined
CJSON_SOURCE          = cJSONFiles.zip
CJSON_SITE            = http://downloads.sourceforge.net/project/cjson/
CJSON_INSTALL_STAGING = YES
CJSON_LICENSE         = MIT

define CJSON_EXTRACT_CMDS
	unzip -d $(@D) $(DL_DIR)/$(CJSON_SOURCE)
endef

define CJSON_BUILD_CMDS
	cd $(@D)/cJSON && $(TARGET_CC) $(TARGET_CFLAGS) -shared -fpic cJSON.c -o libcJSON.so
endef

define CJSON_INSTALL_STAGING_CMDS
	$(INSTALL) -D $(@D)/cJSON/cJSON.h $(STAGING_DIR)/usr/include/cJSON.h
	$(INSTALL) -D $(@D)/cJSON/libcJSON.so $(STAGING_DIR)/usr/lib/libcJSON.so
endef

define CJSON_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/cJSON/cJSON.h $(STAGING_DIR)/usr/include/cJSON.h
	$(INSTALL) -D $(@D)/cJSON/libcJSON.so $(TARGET_DIR)/usr/lib/libcJSON.so
endef

define CJSON_UNINSTALL_STAGING_CMDS
	rm -f $(STAGING_DIR)/usr/include/cJSON.h
	rm -f $(STAGING_DIR)/usr/lib/libcJSON.so
endef

define CJSON_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/include/cJSON.h
	rm -f $(TARGET_DIR)/usr/lib/libcJSON.so
endef

define CJSON_CLEAN_CMDS
	cd $(@D)/cJSON && rm -f libcJSON.so
endef

$(eval $(generic-package))
