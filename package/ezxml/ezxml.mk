################################################################################
#
# ezxml
#
################################################################################

EZXML_VERSION = 0.8.6
EZXML_SOURCE = ezxml-$(EZXML_VERSION).tar.gz
EZXML_SITE = http://downloads.sourceforge.net/project/ezxml/ezXML/ezXML%20$(EZXML_VERSION)
EZXML_INSTALL_STAGING = YES

define EZXML_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" AR=$(TARGET_AR) \
	-f GNUmakefile -C $(@D)
endef

define EZXML_INSTALL_STAGING_CMDS
	install -D -m 0644 $(@D)/ezxml.h $(STAGING_DIR)/usr/include/ezxml.h
	install -D -m 0644 $(@D)/libezxml.a $(STAGING_DIR)/usr/lib/libezxml.a
endef

define EZXML_INSTALL_TARGET_CMDS
	install -D -m 0644 $(@D)/ezxml.h $(TARGET_DIR)/usr/include/ezxml.h
	install -D -m 0644 $(@D)/libezxml.a $(TARGET_DIR)/usr/lib/libezxml.a
endef

define EZXML_UNINSTALL_STAGING_CMDS
	rm -f $(STAGING_DIR)/usr/include/ezxml.h
	rm -f $(STAGING_DIR)/usr/lib/libezxml.a
endef

define EZXML_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/include/ezxml.h
	rm -f $(TARGET_DIR)/usr/lib/libezxml.a
endef

define EZXML_CLEAN_CMDS
	-$(MAKE) -C $(@D) -f GNUmakefile clean
endef

$(eval $(generic-package))
