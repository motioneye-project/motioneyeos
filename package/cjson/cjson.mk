################################################################################
#
# cjson
#
################################################################################

CJSON_VERSION         = 58
CJSON_SITE_METHOD     = svn
CJSON_SITE            = http://svn.code.sf.net/p/cjson/code
CJSON_INSTALL_STAGING = YES
CJSON_LICENSE         = MIT
CJSON_LICENSE_FILES   = LICENSE

define CJSON_BUILD_CMDS
	cd $(@D) && $(TARGET_CC) $(TARGET_CFLAGS) -shared -fPIC cJSON.c -o libcJSON.so
endef

define CJSON_INSTALL_STAGING_CMDS
	$(INSTALL) -D $(@D)/cJSON.h $(STAGING_DIR)/usr/include/cJSON.h
	$(INSTALL) -D $(@D)/libcJSON.so $(STAGING_DIR)/usr/lib/libcJSON.so
endef

define CJSON_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/cJSON.h $(TARGET_DIR)/usr/include/cJSON.h
	$(INSTALL) -D $(@D)/libcJSON.so $(TARGET_DIR)/usr/lib/libcJSON.so
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
	rm -f $(@D)/libcJSON.so
endef

$(eval $(generic-package))
