#############################################################
#
# busybox
#
#############################################################

ifeq ($(USE_BUSYBOX_SNAPSHOT),true)
# Be aware that this changes daily....
BUSYBOX_DIR:=$(BUILD_DIR)/busybox
BUSYBOX_SOURCE=busybox-unstable.tar.bz2
BUSYBOX_SITE:=http://www.busybox.net/downloads/snapshots
BUSYBOX_UNZIP=bzcat
BUSYBOX_CONFIG:=$(SOURCE_DIR)/busybox.config
else
BUSYBOX_DIR:=$(BUILD_DIR)/busybox-0.60.5
BUSYBOX_SOURCE:=busybox-0.60.5.tar.bz2
BUSYBOX_SITE:=http://www.busybox.net/downloads
BUSYBOX_UNZIP=bzcat
BUSYBOX_CONFIG:=$(SOURCE_DIR)/busybox.Config.h
endif

$(DL_DIR)/$(BUSYBOX_SOURCE):
	 $(WGET) -P $(DL_DIR) $(BUSYBOX_SITE)/$(BUSYBOX_SOURCE)

busybox-source: $(DL_DIR)/$(BUSYBOX_SOURCE) $(BUSYBOX_CONFIG)

$(BUSYBOX_DIR)/.configured: $(DL_DIR)/$(BUSYBOX_SOURCE) $(BUSYBOX_CONFIG)
	$(BUSYBOX_UNZIP) $(DL_DIR)/$(BUSYBOX_SOURCE) | tar -C $(BUILD_DIR) -xvf -
ifeq ($(USE_BUSYBOX_SNAPSHOT),true)
	cp $(BUSYBOX_CONFIG) $(BUSYBOX_DIR)/.config
	sed -ie "s,^CROSS.*,CROSS=$(TARGET_CROSS)\n\
		PREFIX=$(TARGET_DIR),;" $(BUSYBOX_DIR)/Rules.mak
ifeq ($(strip $(BUILD_WITH_LARGEFILE)),true)
	sed -ie "s/^.*DOLFS.*/DOLFS=y/;" $(BUSYBOX_DIR)/.config
endif
	$(MAKE) CC=$(TARGET_CC) CROSS="$(TARGET_CROSS)" -C $(BUSYBOX_DIR) oldconfig
else  # Not using snapshot
	cp $(BUSYBOX_CONFIG) $(BUSYBOX_DIR)/Config.h
	sed -ie "s,^CROSS.*,CROSS=$(TARGET_CROSS),;" $(BUSYBOX_DIR)/Makefile
	sed -ie "s,^PREFIX.*,PREFIX=$(TARGET_DIR),;" $(BUSYBOX_DIR)/Makefile
ifeq ($(strip $(BUILD_WITH_LARGEFILE)),true)
	sed -ie "s/^DOLFS.*/DOLFS=true/;" $(BUSYBOX_DIR)/Makefile
endif
endif
	touch $(BUSYBOX_DIR)/.configured

busybox-unpack: $(BUSYBOX_DIR)/.configured

$(BUSYBOX_DIR)/busybox: $(BUSYBOX_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) CROSS="$(TARGET_CROSS)" PREFIX="$(TARGET_DIR)" \
		-C $(BUSYBOX_DIR)

$(TARGET_DIR)/bin/busybox: $(BUSYBOX_DIR)/busybox
	$(MAKE) CC=$(TARGET_CC) CROSS="$(TARGET_CROSS)" PREFIX="$(TARGET_DIR)" \
		-C $(BUSYBOX_DIR) install
	# Just in case
	-chmod a+x $(TARGET_DIR)/usr/share/udhcpc/default.script

busybox: uclibc $(TARGET_DIR)/bin/busybox

busybox-clean:
	rm -f $(TARGET_DIR)/bin/busybox
	-$(MAKE) -C $(BUSYBOX_DIR) clean

busybox-dirclean:
	rm -rf $(BUSYBOX_DIR)
