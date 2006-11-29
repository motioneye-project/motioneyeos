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

BR2_LSOF_CFLAGS:=
ifeq ($(BR2_LARGEFILE),)
BR2_LSOF_CFLAGS+=-U_FILE_OFFSET_BITS
endif
ifeq ($(UCLIBC_HAS_IPV6),)
BR2_LSOF_CFLAGS+=-UHASIPv6
endif

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
	(cd $(LSOF_DIR)/lsof_4.77_src; echo n | $(TARGET_CONFIGURE_OPTS) DEBUG="$(TARGET_CFLAGS) $(BR2_LSOF_CFLAGS)" ./Configure linux)
	touch $(LSOF_DIR)/.configured

$(LSOF_DIR)/lsof_4.77_src/$(LSOF_BINARY): $(LSOF_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) DEBUG="$(TARGET_CFLAGS) $(BR2_LSOF_CFLAGS)" -C $(LSOF_DIR)/lsof_4.77_src

$(TARGET_DIR)/$(LSOF_TARGET_BINARY): $(LSOF_DIR)/lsof_4.77_src/$(LSOF_BINARY)
	cp $(LSOF_DIR)/lsof_4.77_src/$(LSOF_BINARY) $@
	$(STRIP) $@

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
