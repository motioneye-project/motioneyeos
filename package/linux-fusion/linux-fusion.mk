#############################################################
#
# linux-fusion
#
#############################################################
LINUX_FUSION_VERSION = 8.0.2
LINUX_FUSION_SOURCE = linux-fusion-$(LINUX_FUSION_VERSION).tar.gz
LINUX_FUSION_SITE = http://www.directfb.org/downloads/Core/
LINUX_FUSION_AUTORECONF = NO
LINUX_FUSION_INSTALL_STAGING = YES
LINUX_FUSION_INSTALL_TARGET = YES

LINUX_FUSION_CONF_OPT = 

LINUX_FUSION_DEPENDENCIES = uclibc

# BR2_LINUX26_VERSION is not really dependable
# LINUX26_VERSION is not yet set.
# Retrieve REAL kernel version from file.
LINUX_FOR_FUSION=`cat $(PROJECT_BUILD_DIR)/.linux-version`

LINUX_FUSION_DIR:=$(BUILD_DIR)/linux-fusion-$(LINUX_FUSION_VERSION)
LINUX_FUSION_ETC_DIR:=$(TARGET_DIR)/etc/udev/rules.d

LINUX_FUSION_CAT:=$(ZCAT)

LINUX_FUSION_MAKE_OPTS:=  KERNEL_VERSION=$(LINUX_FOR_FUSION)
LINUX_FUSION_MAKE_OPTS += KERNEL_BUILD=$(PROJECT_BUILD_DIR)/linux-$(LINUX_FOR_FUSION)
LINUX_FUSION_MAKE_OPTS += KERNEL_SOURCE=$(PROJECT_BUILD_DIR)/linux-$(LINUX_FOR_FUSION)

LINUX_FUSION_MAKE_OPTS += SYSROOT=$(STAGING_DIR)
LINUX_FUSION_MAKE_OPTS += ARCH=$(BR2_ARCH)
LINUX_FUSION_MAKE_OPTS += CROSS_COMPILE=$(TARGET_CROSS)
LINUX_FUSION_MAKE_OPTS += KERNEL_MODLIB=/lib/modules/$(LINUX_FOR_FUSION)
LINUX_FUSION_MAKE_OPTS += DESTDIR=$(PROJECT_BUILD_DIR)/root
LINUX_FUSION_MAKE_OPTS += HEADERDIR=$(STAGING_DIR)
#LINUX_FUSION_MAKE_OPTS += 

#LINUX_FUSION_MAKE_OPTS += __KERNEL__=$(LINUX26_VERSION)

$(DL_DIR)/$(LINUX_FUSION_SOURCE):
	$(call DOWNLOAD,$(LINUX_FUSION_SITE),$(LINUX_FUSION_SOURCE))

$(LINUX_FUSION_DIR)/.unpacked: $(DL_DIR)/$(LINUX_FUSION_SOURCE)
	$(LINUX_FUSION_CAT) $(DL_DIR)/$(LINUX_FUSION_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LINUX_FUSION_DIR) package/linux-fusion/ linux-fusion\*.patch
	touch $@

$(LINUX_FUSION_DIR)/.install: $(LINUX_FUSION_DIR)/.unpacked
	mkdir -p $(STAGING_DIR)/lib/modules/$(LINUX_FOR_FUSION)/source/include/linux
	echo "LINUX=$(LINUX26_VERSION)"
	$(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(LINUX_FUSION_MAKE_OPTS) \
		-C $(LINUX_FUSION_DIR) install
	rm -f $(TARGET_DIR)/usr/include/linux/fusion.h
	mkdir -p $(LINUX_FUSION_ETC_DIR)
	cp -dpf package/linux-fusion/40-fusion.rules $(LINUX_FUSION_ETC_DIR)
	touch $@


linux-fusion-source: $(DL_DIR)/$(LINUX_FUSION_SOURCE)

linux-fusion-unpacked: $(LINUX_FUSION_DIR)/.unpacked

linux-fusion: uclibc linux26 $(LINUX_FUSION_DIR)/.install

linux-fusion-clean:
	-$(MAKE) -C $(LINUX_FUSION_DIR) clean
	rm -f $(STAGING_DIR)/usr/include/linux/fusion.h
	rm -rf $(TARGET_DIR)/lib/modules/$(LINUX_FOR_FUSION)/drivers/char/fusion
	rm -f $(LINUX_FUSION_DIR)/.install

linux-fusion-dirclean:
	rm -rf $(LINUX_FUSION_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_LINUX_FUSION),y)
TARGETS+=linux-fusion
endif

