#############################################################
#
# lsof
#
#############################################################
LSOF_SOURCE:=lsof_4.77.tar.bz2
LSOF_SITE:=ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/
LSOF_CAT:=$(BZCAT)
LSOF_DIR:=$(BUILD_DIR)/lsof_4.77
LSOF_BINARY:=lsof
LSOF_TARGET_BINARY:=bin/lsof

$(DL_DIR)/$(LSOF_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LSOF_SITE)/$(LSOF_SOURCE)

lsof-source: $(DL_DIR)/$(LSOF_SOURCE)

lsof-unpacked: $(LSOF_DIR)/.unpacked

$(LSOF_DIR)/.unpacked: $(DL_DIR)/$(LSOF_SOURCE)
	$(LSOF_CAT) $(DL_DIR)/$(LSOF_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	(cd $(LSOF_DIR);tar xf lsof_4.77_src.tar;rm -f lsof_4.77_src.tar)
	toolchain/patch-kernel.sh $(LSOF_DIR) package/lsof/ \*.patch
	touch $(LSOF_DIR)/.unpacked

$(LSOF_DIR)/.configured: $(LSOF_DIR)/.unpacked
	(cd $(LSOF_DIR)/lsof_4.77_src; echo n | CC="$(CC)" CFLAGS="$(CFLAGS)" ./Configure linux)
	touch $(LSOF_DIR)/.configured

$(LSOF_DIR)/lsof_4.77_src/$(LSOF_BINARY): $(LSOF_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LSOF_DIR)/lsof_4.77_src

$(TARGET_DIR)/$(LSOF_TARGET_BINARY): $(LSOF_DIR)/lsof_4.77_src/$(LSOF_BINARY)
	cp -a $(LSOF_DIR)/lsof_4.77_src/$(LSOF_BINARY) $(TARGET_DIR)/$(LSOF_TARGET_BINARY)

lsof: uclibc $(TARGET_DIR)/$(LSOF_TARGET_BINARY)

lsof-clean:
	-rm -f $(TARGET_DIR)/$(LSOF_TARGET_BINARY)
	-$(MAKE) -C $(LSOF_DIR)/lsof_4.77_src clean

lsof-dirclean:
	rm -rf $(LSOF_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LSOF)),y)
TARGETS+=lsof
endif
