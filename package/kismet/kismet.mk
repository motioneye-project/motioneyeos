#############################################################
#
# kismet
#
#############################################################

KISMET_VERSION = 2010-01-R1
KISMET_SITE = http://www.kismetwireless.net/code
KISMET_DEPENDENCIES = libpcap ncurses

ifeq ($(BR2_PACKAGE_LIBNL),y)
	KISMET_DEPENDENCIES += libnl
endif
ifeq ($(BR2_PACKAGE_PCRE),y)
	KISMET_DEPENDENCIES += pcre
endif

ifeq ($(BR2_PACKAGE_KISMET_CLIENT),y)
	KISMET_TARGET_BINARIES += kismet_client
endif

ifeq ($(BR2_PACKAGE_KISMET_SERVER),y)
	KISMET_TARGET_BINARIES += kismet_server
	KISMET_TARGET_CONFIGS += kismet.conf
endif

ifeq ($(BR2_PACKAGE_KISMET_DRONE),y)
	KISMET_TARGET_BINARIES += kismet_drone
	KISMET_TARGET_CONFIGS += kismet_drone.conf
endif

$(eval $(call AUTOTARGETS,package,kismet))

$(KISMET_TARGET_INSTALL_TARGET):
	$(call MESSAGE,"Installing")
	$(INSTALL) -m 755 $(addprefix $(KISMET_DIR)/, $(KISMET_TARGET_BINARIES)) $(TARGET_DIR)/usr/bin
ifdef KISMET_TARGET_CONFIGS
	$(INSTALL) -m 644 $(addprefix $(KISMET_DIR)/conf/, $(KISMET_TARGET_CONFIGS)) $(TARGET_DIR)/etc
endif
ifeq ($(BR2_ENABLE_DEBUG),)
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(addprefix $(TARGET_DIR)/usr/bin/, $(KISMET_TARGET_BINARIES))
endif
	touch $@

$(KISMET_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, $(KISMET_TARGET_BINARIES))
ifdef KISMET_TARGET_CONFIGS
	rm -f $(addprefix $(TARGET_DIR)/etc/, $(KISMET_TARGET_CONFIGS))
endif
	rm -f $(KISMET_TARGET_INSTALL_TARGET) $(KISMET_HOOK_POST_INSTALL)
