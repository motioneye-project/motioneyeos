#############################################################
#
# concierge 1.0-RC2
#
#############################################################
CONCIERGE_VERSION = 1.0_RC2
CONCIERGE_SOURCE = concierge-$(CONCIERGE_VERSION).jar
CONCIERGE_SITE = http://ovh.dl.sourceforge.net/sourceforge/concierge/
CONCIERGE_DIR=$(BUILD_DIR)/concierge-$(CONCIERGE_VERSION)
CONCIERGE_SITE_BUNDLES = http://concierge.sourceforge.net/bundles/

$(DL_DIR)/concierge:
	 mkdir -p $(DL_DIR)/concierge/
	 $(WGET) -P $(DL_DIR)/concierge/ $(CONCIERGE_SITE)/concierge-$(CONCIERGE_VERSION).jar
	 $(WGET) -P $(DL_DIR)/concierge/ $(CONCIERGE_SITE_BUNDLES)shell-1.0.0.RC2.jar
	 $(WGET) -P $(DL_DIR)/concierge/ $(CONCIERGE_SITE_BUNDLES)service-tracker-1.0.0.RC2.jar
	 $(WGET) -P $(DL_DIR)/concierge/ $(CONCIERGE_SITE_BUNDLES)event-admin-1.0.0.RC2.jar

$(TARGET_DIR)/usr/lib/concierge/: $(DL_DIR)/concierge
	mkdir -p $(TARGET_DIR)/usr/lib
	mkdir -p $(TARGET_DIR)/usr/lib/concierge
	cp -dpf $(DL_DIR)/concierge/* $(TARGET_DIR)/usr/lib/concierge/
	cp -dpf package/java/concierge/files/init.xargs $(TARGET_DIR)/usr/lib/concierge/
	touch -c $@

$(TARGET_DIR)/usr/bin/concierge:
	cp -dpf package/java/concierge/files/concierge $(TARGET_DIR)/usr/bin/
	chmod +x $(TARGET_DIR)/usr/bin/concierge
	touch -c $@

concierge: $(TARGET_DIR)/usr/lib/concierge $(TARGET_DIR)/usr/bin/concierge

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_CONCIERGE),y)
TARGETS+=concierge
endif
