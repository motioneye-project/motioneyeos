#############################################################
#
# busybox
#
#############################################################
ifeq ($(USE_BUSYBOX_SNAPSHOT),true)
# Be aware that this changes daily....
BUSYBOX_DIR:=$(BUILD_DIR)/busybox
BUSYBOX_SOURCE=busybox-snapshot.tar.bz2
BUSYBOX_SITE:=http://www.busybox.net/downloads/snapshots
UNZIP=bzcat
else
BUSYBOX_DIR:=$(BUILD_DIR)/busybox-0.60.2
BUSYBOX_SOURCE:=busybox-0.60.2.tar.gz
BUSYBOX_SITE:=http://www.busybox.net/downloads
UNZIP=zcat
endif
BUSYBOX_PATCH:=$(SOURCE_DIR)/busybox.patch


$(DL_DIR)/$(BUSYBOX_SOURCE):
	 wget -P $(DL_DIR) --passive-ftp $(BUSYBOX_SITE)/$(BUSYBOX_SOURCE)

busybox-source: $(DL_DIR)/$(BUSYBOX_SOURCE) $(BUSYBOX_PATCH)

$(BUSYBOX_DIR)/Config.h: $(DL_DIR)/$(BUSYBOX_SOURCE) $(BUSYBOX_PATCH)
	$(UNZIP) $(DL_DIR)/$(BUSYBOX_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	cat $(BUSYBOX_PATCH) | patch -d $(BUSYBOX_DIR) -p1
ifeq ($(strip $(BUILD_WITH_LARGEFILE)),true)
	perl -i -p -e "s/^DOLFS.*/DOLFS=true/;" $(BUSYBOX_DIR)/Makefile
endif

$(BUSYBOX_DIR)/busybox: $(BUSYBOX_DIR)/Config.h
	make CROSS="$(TARGET_CROSS)" PREFIX="$(TARGET_DIR)" -C $(BUSYBOX_DIR)

$(TARGET_DIR)/bin/busybox: $(BUSYBOX_DIR)/busybox
	make CROSS="$(TARGET_CROSS)" PREFIX="$(TARGET_DIR)" -C $(BUSYBOX_DIR) install

busybox: uclibc $(TARGET_DIR)/bin/busybox

busybox-clean:
	rm -f $(TARGET_DIR)/bin/busybox
	-make -C $(BUSYBOX_DIR) clean

busybox-dirclean:
	rm -rf $(BUSYBOX_DIR)
