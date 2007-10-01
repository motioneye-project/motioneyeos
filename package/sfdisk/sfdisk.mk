#############################################################
#
# sfdisk support
#
#############################################################
SFDISK_VERSION:=
SFDISK_SOURCE=sfdisk$(SFDISK_VERSION).tar.bz2
SFDISK_CAT:=$(BZCAT)
SFDISK_SITE:=http://www.uclibc.org/
SFDISK_DIR=$(BUILD_DIR)/sfdisk$(SFDISK_VERSION)

$(DL_DIR)/$(SFDISK_SOURCE):
	$(WGET) -P $(DL_DIR) $(SFDISK_SITE)/$(SFDISK_SOURCE)

$(SFDISK_DIR)/.patched: $(DL_DIR)/$(SFDISK_SOURCE)
	$(SFDISK_CAT) $(DL_DIR)/$(SFDISK_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(SFDISK_DIR) package/sfdisk/ sfdisk.\*.patch
	touch $@


$(SFDISK_DIR)/sfdisk: $(SFDISK_DIR)/.patched
	$(MAKE) \
		CROSS=$(TARGET_CROSS) DEBUG=false OPTIMIZATION="$(TARGET_CFLAGS)" \
		-C $(SFDISK_DIR)
	-$(STRIPCMD) $(SFDISK_DIR)/sfdisk
	touch -c $(SFDISK_DIR)/sfdisk

$(TARGET_DIR)/sbin/sfdisk: $(SFDISK_DIR)/sfdisk
	cp $(SFDISK_DIR)/sfdisk $(TARGET_DIR)/sbin/sfdisk
	touch -c $(TARGET_DIR)/sbin/sfdisk

sfdisk: uclibc $(TARGET_DIR)/sbin/sfdisk

sfdisk-source: $(DL_DIR)/$(SFDISK_SOURCE)

sfdisk-clean:
	rm -f $(TARGET_DIR)/sbin/sfdisk
	-$(MAKE) -C $(SFDISK_DIR) clean

sfdisk-dirclean:
	rm -rf $(SFDISK_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_SFDISK)),y)
TARGETS+=sfdisk
endif
