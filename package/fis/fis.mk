#############################################################
#
# fis
#
#############################################################
FIS_SOURCE:=fis.c
FIS_SITE:=http://svn.chezphil.org/utils/trunk
FIS_CAT:=$(ZCAT)
FIS_DIR:=$(BUILD_DIR)/fis
FIS_BINARY:=fis
FIS_TARGET_BINARY:=sbin/fis

$(DL_DIR)/$(FIS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(FIS_SITE)/$(FIS_SOURCE)

fis-source: $(DL_DIR)/$(FIS_SOURCE)

$(FIS_DIR)/.unpacked: $(DL_DIR)/$(FIS_SOURCE)
	mkdir -p $(FIS_DIR)
	cp -f $(DL_DIR)/$(FIS_SOURCE) $(FIS_DIR)
	toolchain/patch-kernel.sh $(FIS_DIR) package/fis \*.patch
	touch $@

$(FIS_DIR)/$(FIS_BINARY): $(FIS_DIR)/.unpacked
	$(MAKE) -C $(FIS_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -std=c99" \
		LDFLAGS="$(TARGET_LDFLAGS)"

$(TARGET_DIR)/$(FIS_TARGET_BINARY): $(FIS_DIR)/$(FIS_BINARY)
	rm -f $(TARGET_DIR)/$(FIS_TARGET_BINARY)
	$(INSTALL) -D -m 0755 $(FIS_DIR)/$(FIS_BINARY) $(TARGET_DIR)/$(FIS_TARGET_BINARY)
	$(STRIPCMD) $(STRIP_STRIP_ALL) $@

fis: uclibc $(TARGET_DIR)/$(FIS_TARGET_BINARY)

fis-clean:
	-$(MAKE) -C $(FIS_DIR) clean
	rm -f $(TARGET_DIR)/$(FIS_TARGET_BINARY)

fis-dirclean:
	rm -rf $(FIS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_FIS)),y)
TARGETS+=fis
endif
