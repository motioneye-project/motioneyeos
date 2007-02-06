#############################################################
#
# busybox
#
#############################################################

ifeq ($(strip $(BR2_BUSYBOX_VERSION_1_0_1)),y)
BUSYBOX_VER:=1.0.1
BUSYBOX_DIR:=$(BUILD_DIR)/busybox-$(BUSYBOX_VER)
BUSYBOX_SOURCE:=busybox-$(BUSYBOX_VER).tar.bz2
BUSYBOX_SITE:=http://www.busybox.net/downloads
endif

ifeq ($(strip $(BR2_BUSYBOX_VERSION_1_1_3)),y)
BUSYBOX_VER:=1.1.3
BUSYBOX_DIR:=$(BUILD_DIR)/busybox-$(BUSYBOX_VER)
BUSYBOX_SOURCE:=busybox-$(BUSYBOX_VER).tar.bz2
BUSYBOX_SITE:=http://www.busybox.net/downloads
endif

ifeq ($(strip $(BR2_BUSYBOX_VERSION_1_2_2_1)),y)
BUSYBOX_VER:=1.2.2.1
BUSYBOX_DIR:=$(BUILD_DIR)/busybox-$(BUSYBOX_VER)
BUSYBOX_SOURCE:=busybox-$(BUSYBOX_VER).tar.bz2
BUSYBOX_SITE:=http://www.busybox.net/downloads
endif

ifeq ($(strip $(BR2_BUSYBOX_VERSION_1_4_0)),y)
BUSYBOX_VER:=1.4.0
BUSYBOX_DIR:=$(BUILD_DIR)/busybox-$(BUSYBOX_VER)
BUSYBOX_SOURCE:=busybox-$(BUSYBOX_VER).tar.bz2
BUSYBOX_SITE:=http://www.busybox.net/downloads
endif

ifeq ($(strip $(BR2_BUSYBOX_VERSION_1_4_1)),y)
BUSYBOX_VER:=1.4.1
BUSYBOX_DIR:=$(BUILD_DIR)/busybox-$(BUSYBOX_VER)
BUSYBOX_SOURCE:=busybox-$(BUSYBOX_VER).tar.bz2
BUSYBOX_SITE:=http://www.busybox.net/downloads
endif

ifeq ($(strip $(BR2_PACKAGE_BUSYBOX_SNAPSHOT)),y)
# Be aware that this changes daily....
BUSYBOX_DIR:=$(BUILD_DIR)/busybox
BUSYBOX_SOURCE:=busybox-snapshot.tar.bz2
BUSYBOX_SITE:=http://www.busybox.net/downloads/snapshots
endif

BUSYBOX_UNZIP=$(BZCAT)

ifndef BUSYBOX_CONFIG_FILE
BUSYBOX_CONFIG_FILE=$(subst ",, $(strip $(BR2_PACKAGE_BUSYBOX_CONFIG)))
#")
endif

$(DL_DIR)/$(BUSYBOX_SOURCE):
	 $(WGET) -P $(DL_DIR) $(BUSYBOX_SITE)/$(BUSYBOX_SOURCE)

busybox-source: $(DL_DIR)/$(BUSYBOX_SOURCE) $(BUSYBOX_CONFIG_FILE) dependencies

$(BUSYBOX_DIR)/.unpacked: $(DL_DIR)/$(BUSYBOX_SOURCE)
	$(BUSYBOX_UNZIP) $(DL_DIR)/$(BUSYBOX_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
ifeq ($(BR2_PACKAGE_SYSKLOGD),y)
	# if we have external syslogd, force busybox to use it
	$(SED) "/#include.*busybox\.h/a#define CONFIG_SYSLOGD" $(BUSYBOX_DIR)/init/init.c
endif
	# Allow busybox patches.
ifeq ($(strip $(BR2_PACKAGE_BUSYBOX_SNAPSHOT)),y)
	toolchain/patch-kernel.sh $(BUSYBOX_DIR) package/busybox busybox.\*.patch
else
	toolchain/patch-kernel.sh $(BUSYBOX_DIR) package/busybox busybox-$(BUSYBOX_VER)-\*.patch
endif
	touch $@

$(BUSYBOX_DIR)/.configured: $(BUSYBOX_DIR)/.unpacked $(BUSYBOX_CONFIG_FILE)
	cp -f $(BUSYBOX_CONFIG_FILE) $(BUSYBOX_DIR)/.config
ifeq ($(strip $(BR2_BUSYBOX_VERSION_1_0_1)),y)
	$(SED) "s,^CROSS.*,CROSS=$(TARGET_CROSS)\n\PREFIX=$(TARGET_DIR),;" \
		$(BUSYBOX_DIR)/Rules.mak ;
endif
ifeq ($(strip $(BR2_BUSYBOX_VERSION_1_1_3)),y)
	$(SED) s,^CONFIG_PREFIX=.*,CONFIG_PREFIX=\"$(TARGET_DIR)\", \
		$(BUSYBOX_DIR)/.config ;
	$(SED) s,^PREFIX=.*,CONFIG_PREFIX=\"$(TARGET_DIR)\", \
		$(BUSYBOX_DIR)/.config ;
endif
ifeq ($(strip $(BR2_BUSYBOX_VERSION_1_2_2_1)),y)
	$(SED) s,^CROSS_COMPILER_PREFIX=.*,CROSS_COMPILER_PREFIX=\"$(TARGET_CROSS)\", \
		$(BUSYBOX_DIR)/.config ;
	$(SED) s,^PREFIX=.*,CROSS_COMPILER_PREFIX=\"$(TARGET_CROSS)\", \
		$(BUSYBOX_DIR)/.config ;
endif
# either 1.4.0 or 1.4.1
ifneq ($(strip $(BR2_BUSYBOX_VERSION_1_4_0))$(strip $(BR2_BUSYBOX_VERSION_1_4_1)),)
	$(SED) s,^PREFIX=.*,CONFIG_PREFIX=\"$(TARGET_DIR)\", \
		$(BUSYBOX_DIR)/.config ;
endif
ifeq ($(strip $(BR2_PACKAGE_BUSYBOX_SNAPSHOT)),y)
	$(SED) s,^CONFIG_PREFIX=.*,CONFIG_PREFIX=\"$(TARGET_DIR)\", \
		$(BUSYBOX_DIR)/.config ;
	$(SED) s,^CROSS_COMPILER_PREFIX=.*,CROSS_COMPILER_PREFIX=\"$(TARGET_CROSS)\", \
		$(BUSYBOX_DIR)/.config ;
	$(SED) s,^PREFIX=.*,CROSS_COMPILER_PREFIX=\"$(TARGET_CROSS)\", \
		$(BUSYBOX_DIR)/.config ;
endif
ifeq ($(BR2_LARGEFILE),y)
	$(SED) "s/^.*CONFIG_LFS.*/CONFIG_LFS=y/;" $(BUSYBOX_DIR)/.config
else
	$(SED) "s/^.*CONFIG_LFS.*/CONFIG_LFS=n/;" $(BUSYBOX_DIR)/.config
	$(SED) "s/^.*FDISK_SUPPORT_LARGE_DISKS.*/FDISK_SUPPORT_LARGE_DISKS=n/;" $(BUSYBOX_DIR)/.config
endif
	yes "" | $(MAKE) CC=$(TARGET_CC) CROSS_COMPILE="$(TARGET_CROSS)" \
		CROSS="$(TARGET_CROSS)" -C $(BUSYBOX_DIR) oldconfig
	touch $@


$(BUSYBOX_DIR)/busybox: $(BUSYBOX_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) CROSS_COMPILE="$(TARGET_CROSS)" \
		CROSS="$(TARGET_CROSS)" PREFIX="$(TARGET_DIR)" \
		ARCH=$(KERNEL_ARCH) \
		EXTRA_CFLAGS="$(TARGET_CFLAGS)" -C $(BUSYBOX_DIR)
ifeq ($(BR2_PREFER_IMA)$(BR2_PACKAGE_BUSYBOX_SNAPSHOT),yy)
	rm -f $@
	$(MAKE) CC=$(TARGET_CC) CROSS_COMPILE="$(TARGET_CROSS)" \
		CROSS="$(TARGET_CROSS)" PREFIX="$(TARGET_DIR)" \
		ARCH=$(KERNEL_ARCH) STRIP="$(STRIP)" \
		EXTRA_CFLAGS="$(TARGET_CFLAGS)" -C $(BUSYBOX_DIR) \
		-f scripts/Makefile.IMA
endif

$(TARGET_DIR)/bin/busybox: $(BUSYBOX_DIR)/busybox
ifeq ($(BR2_PACKAGE_BUSYBOX_INSTALL_SYMLINKS),y)
	$(MAKE) CC=$(TARGET_CC) CROSS_COMPILE="$(TARGET_CROSS)" \
		CROSS="$(TARGET_CROSS)" PREFIX="$(TARGET_DIR)" \
		CONFIG_PREFIX="$(TARGET_DIR)" ARCH=$(KERNEL_ARCH) \
		EXTRA_CFLAGS="$(TARGET_CFLAGS)" -C $(BUSYBOX_DIR) install
else
	install -D -m 0755 $(BUSYBOX_DIR)/busybox $(TARGET_DIR)/bin/busybox
endif
	# Just in case
	-chmod a+x $(TARGET_DIR)/usr/share/udhcpc/default.script

busybox: uclibc $(TARGET_DIR)/bin/busybox

busybox-menuconfig: busybox-source $(BUSYBOX_DIR)/.configured
	$(MAKE) __TARGET_ARCH=$(ARCH) -C $(BUSYBOX_DIR) menuconfig
	cp -f $(BUSYBOX_DIR)/.config $(BUSYBOX_CONFIG_FILE)

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
