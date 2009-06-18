#############################################################
#
# dosfstools
#
#############################################################
DOSFSTOOLS_VERSION:=3.0.3
DOSFSTOOLS_SOURCE:=dosfstools-$(DOSFSTOOLS_VERSION).tar.gz
DOSFSTOOLS_SITE:=http://www.daniel-baumann.ch/software/dosfstools
DOSFSTOOLS_DIR:=$(BUILD_DIR)/dosfstools-$(DOSFSTOOLS_VERSION)
DOSFSTOOLS_CAT:=$(ZCAT)
MKDOSFS_BINARY:=mkdosfs
MKDOSFS_TARGET_BINARY:=sbin/mkdosfs
DOSFSCK_BINARY:=dosfsck
DOSFSCK_TARGET_BINARY:=sbin/dosfsck
DOSFSLABEL_BINARY:=dosfslabel
DOSFSLABEL_TARGET_BINARY:=sbin/dosfslabel

$(DL_DIR)/$(DOSFSTOOLS_SOURCE):
	 $(call DOWNLOAD,$(DOSFSTOOLS_SITE),$(DOSFSTOOLS_SOURCE))

dosfstools-source: $(DL_DIR)/$(DOSFSTOOLS_SOURCE)

$(DOSFSTOOLS_DIR)/.unpacked: $(DL_DIR)/$(DOSFSTOOLS_SOURCE) $(wildcard local/dosfstools/dosfstools*.patch)
	$(DOSFSTOOLS_CAT) $(DL_DIR)/$(DOSFSTOOLS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(DOSFSTOOLS_DIR) package/dosfstools/ dosfstools\*.patch
	touch $(DOSFSTOOLS_DIR)/.unpacked

$(DOSFSTOOLS_DIR)/.built : $(DOSFSTOOLS_DIR)/.unpacked
	$(MAKE) CFLAGS="$(TARGET_CFLAGS)" CC="$(TARGET_CC)" -C $(DOSFSTOOLS_DIR)
	$(STRIPCMD) $(DOSFSTOOLS_DIR)/$(MKDOSFS_BINARY)
	$(STRIPCMD) $(DOSFSTOOLS_DIR)/$(DOSFSCK_BINARY)
	$(STRIPCMD) $(DOSFSTOOLS_DIR)/$(DOSFSLABEL_BINARY)
	touch $@

$(TARGET_DIR)/$(MKDOSFS_TARGET_BINARY): $(DOSFSTOOLS_DIR)/.built
	cp -a $(DOSFSTOOLS_DIR)/$(MKDOSFS_BINARY) $@
	touch -c $@

$(TARGET_DIR)/$(DOSFSCK_TARGET_BINARY): $(DOSFSTOOLS_DIR)/.built
	cp -a $(DOSFSTOOLS_DIR)/$(DOSFSCK_BINARY) $@
	touch -c $@

$(TARGET_DIR)/$(DOSFSLABEL_TARGET_BINARY): $(DOSFSTOOLS_DIR)/.built
	cp -a $(DOSFSTOOLS_DIR)/$(DOSFSLABEL_BINARY) $@
	touch -c $@

dosfstools: uclibc $(TARGET_DIR)/$(DOSFSTOOLS_TARGET_BINARY) $(TARGET_DIR)/$(DOSFSCK_TARGET_BINARY)

dosfstools-clean:
	rm -f $(TARGET_DIR)/$(MKDOSFS_TARGET_BINARY)
	rm -f $(TARGET_DIR)/$(DOSFSCK_TARGET_BINARY)
	rm -f $(TARGET_DIR)/$(DOSFSLABEL_TARGET_BINARY)
	-$(MAKE) -C $(DOSFSTOOLS_DIR) clean

dosfstools-dirclean:
	rm -rf $(DOSFSTOOLS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_DOSFSTOOLS_MKDOSFS),y)
TARGETS+=$(TARGET_DIR)/$(MKDOSFS_TARGET_BINARY)
endif

ifeq ($(BR2_PACKAGE_DOSFSTOOLS_DOSFSCK),y)
TARGETS+=$(TARGET_DIR)/$(DOSFSCK_TARGET_BINARY)
endif

ifeq ($(BR2_PACKAGE_DOSFSTOOLS_DOSFSLABEL),y)
TARGETS+=$(TARGET_DIR)/$(DOSFSLABEL_TARGET_BINARY)
endif
