#############################################################
#
# busybox
#
#############################################################

ifeq ($(strip $(BR2_PACKAGE_BUSYBOX_SNAPSHOT)),y)
# Be aware that this changes daily....
BUSYBOX_DIR:=$(BUILD_DIR)/busybox
BUSYBOX_SOURCE:=busybox-snapshot.tar.bz2
BUSYBOX_SITE:=http://www.busybox.net/downloads/snapshots
else
BUSYBOX_VER:=1.2.2
BUSYBOX_DIR:=$(BUILD_DIR)/busybox-$(BUSYBOX_VER)
BUSYBOX_SOURCE:=busybox-$(BUSYBOX_VER).tar.bz2
BUSYBOX_SITE:=http://www.busybox.net/downloads
endif
BUSYBOX_UNZIP=bzcat

BUSYBOX_CONFIG_FILE=$(subst ",, $(strip $(BR2_PACKAGE_BUSYBOX_CONFIG)))
#"

$(DL_DIR)/$(BUSYBOX_SOURCE):
	 $(WGET) -P $(DL_DIR) $(BUSYBOX_SITE)/$(BUSYBOX_SOURCE)

busybox-source: $(DL_DIR)/$(BUSYBOX_SOURCE) $(BUSYBOX_CONFIG_FILE) $(BUILD_DIR) host-sed

$(BUSYBOX_DIR)/.unpacked: $(DL_DIR)/$(BUSYBOX_SOURCE)
	$(BUSYBOX_UNZIP) $(DL_DIR)/$(BUSYBOX_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
ifeq ($(BR2_PACKAGE_SYSKLOGD),y)
	# if we have external syslogd, force busybox to use it
	$(SED) "/#include.*busybox\.h/a#define CONFIG_SYSLOGD" $(BUSYBOX_DIR)/init/init.c
endif
	# Allow busybox patches.
	toolchain/patch-kernel.sh $(BUSYBOX_DIR) package/busybox busybox\*.patch
	touch $(BUSYBOX_DIR)/.unpacked

$(BUSYBOX_DIR)/.configured: $(BUSYBOX_DIR)/.unpacked $(BUSYBOX_CONFIG_FILE)
	cp $(BUSYBOX_CONFIG_FILE) $(BUSYBOX_DIR)/.config
	$(SED) "s,^CROSS.*,CROSS=$(TARGET_CROSS)\n\
		PREFIX=$(TARGET_DIR),;" $(BUSYBOX_DIR)/Rules.mak
ifeq ($(BR2_LARGEFILE),y)
	$(SED) "s/^.*CONFIG_LFS.*/CONFIG_LFS=y/;" $(BUSYBOX_DIR)/.config
else
	$(SED) "s/^.*CONFIG_LFS.*/CONFIG_LFS=n/;" $(BUSYBOX_DIR)/.config
	$(SED) "s/^.*FDISK_SUPPORT_LARGE_DISKS.*/FDISK_SUPPORT_LARGE_DISKS=n/;" $(BUSYBOX_DIR)/.config
endif
	yes "" | $(MAKE) CC=$(TARGET_CC) CROSS="$(TARGET_CROSS)" -C $(BUSYBOX_DIR) oldconfig
	touch $(BUSYBOX_DIR)/.configured

$(BUSYBOX_DIR)/busybox: $(BUSYBOX_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) CROSS_COMPILE="$(TARGET_CROSS)" CROSS="$(TARGET_CROSS)" PREFIX="$(TARGET_DIR)" \
		EXTRA_CFLAGS="$(TARGET_CFLAGS)" -C $(BUSYBOX_DIR)

$(TARGET_DIR)/bin/busybox: $(BUSYBOX_DIR)/busybox
ifeq ($(BR2_PACKAGE_BUSYBOX_INSTALL_SYMLINKS),y)
	$(MAKE) CC=$(TARGET_CC) CROSS="$(TARGET_CROSS)" PREFIX="$(TARGET_DIR)" \
		EXTRA_CFLAGS="$(TARGET_CFLAGS)" -C $(BUSYBOX_DIR) install
else
	install -D -m 0755 $(BUSYBOX_DIR)/busybox $(TARGET_DIR)/bin/busybox
endif
	# Just in case
	-chmod a+x $(TARGET_DIR)/usr/share/udhcpc/default.script

busybox: uclibc $(TARGET_DIR)/bin/busybox

busybox-menuconfig: $(BUSYBOX_DIR)/.configured
	$(MAKE) __TARGET_ARCH=$(ARCH) -C $(BUSYBOX_DIR) menuconfig

busybox-clean:
	rm -f $(TARGET_DIR)/bin/busybox
	-$(MAKE) -C $(BUSYBOX_DIR) clean

busybox-dirclean:
	rm -rf $(BUSYBOX_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_BUSYBOX)),y)
TARGETS+=busybox
endif
