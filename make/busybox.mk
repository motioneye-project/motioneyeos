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
BUSYBOX_UNZIP=bzcat
BUSYBOX_PATCH:=$(SOURCE_DIR)/busybox.patch
else
BUSYBOX_DIR:=$(BUILD_DIR)/busybox-0.60.4
BUSYBOX_SOURCE:=busybox-0.60.4.tar.bz2
BUSYBOX_SITE:=http://www.busybox.net/downloads
BUSYBOX_UNZIP=bzcat
BUSYBOX_PATCH:=$(SOURCE_DIR)/busybox.patch
endif

$(DL_DIR)/$(BUSYBOX_SOURCE):
	 wget -P $(DL_DIR) --passive-ftp $(BUSYBOX_SITE)/$(BUSYBOX_SOURCE)

busybox-source: $(DL_DIR)/$(BUSYBOX_SOURCE) $(BUSYBOX_PATCH)

$(BUSYBOX_DIR)/.configured: $(DL_DIR)/$(BUSYBOX_SOURCE) $(BUSYBOX_PATCH)
	$(BUSYBOX_UNZIP) $(DL_DIR)/$(BUSYBOX_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	if [ -n "$(BUSYBOX_PATCH)" ] ; then \
	cat $(BUSYBOX_PATCH) | patch -d $(BUSYBOX_DIR) -p1; fi
	perl -i -p -e "s,^CROSS.*,CROSS=$(TARGET_CROSS),;" $(BUSYBOX_DIR)/Makefile
	perl -i -p -e "s,^PREFIX.*,PREFIX=$(TARGET_DIR),;" $(BUSYBOX_DIR)/Makefile
	perl -i -p -e "s/^MD5SUM_SIZE_VS_SPEED.*/MD5SUM_SIZE_VS_SPEED 0/;" $(BUSYBOX_DIR)/md5sum.c
ifeq ($(strip $(BUILD_WITH_LARGEFILE)),true)
	perl -i -p -e "s/^DOLFS.*/DOLFS=true/;" $(BUSYBOX_DIR)/Makefile
endif
	touch $(BUSYBOX_DIR)/.configured

busybox-unpack: $(BUSYBOX_DIR)/.configured

$(BUSYBOX_DIR)/busybox: $(BUSYBOX_DIR)/.configured
	$(MAKE) CROSS="$(TARGET_CROSS)" PREFIX="$(TARGET_DIR)" -C $(BUSYBOX_DIR)

$(TARGET_DIR)/bin/busybox: $(BUSYBOX_DIR)/busybox
	$(MAKE) CROSS="$(TARGET_CROSS)" PREFIX="$(TARGET_DIR)" -C $(BUSYBOX_DIR) install

busybox: uclibc $(TARGET_DIR)/bin/busybox

busybox-clean:
	rm -f $(TARGET_DIR)/bin/busybox
	-$(MAKE) -C $(BUSYBOX_DIR) clean

busybox-dirclean:
	rm -rf $(BUSYBOX_DIR)
