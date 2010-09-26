#############################################################
#
# ezxml
#
#############################################################
EZXML_VERSION = 0.8.6
EZXML_SOURCE = ezxml-$(EZXML_VERSION).tar.gz
EZXML_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/ezxml/
EZXML_INSTALL_STAGING=YES

define EZXML_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" AR=$(TARGET_AR) \
	-f GNUmakefile -C $(@D)
endef

define EZXML_INSTALL_STAGING_CMDS
	cp $(@D)/ezxml.h $(STAGING_DIR)/usr/include
	cp $(@D)/libezxml.a $(STAGING_DIR)/usr/lib
endef

define EZXML_CLEAN_CMDS
	-$(MAKE) -C $(@D) -f GNUmakefile clean
endef

$(eval $(call GENTARGETS,package,ezxml))
