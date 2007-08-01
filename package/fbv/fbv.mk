#############################################################
#
# fbv
#
#############################################################
FBV_VERSION:=1.0b
FBV_SOURCE:=fbv-$(FBV_VERSION).tar.gz
FBV_SITE:=http://s-tech.elsat.net.pl/fbv
FBV_DIR:=$(BUILD_DIR)/fbv-$(FBV_VERSION)
FBV_CAT:=$(ZCAT)
FBV_BINARY:=fbv
FBV_TARGET_BINARY:=usr/bin/$(FBV_BINARY)

$(DL_DIR)/$(FBV_SOURCE):
	$(WGET) -P $(DL_DIR) $(FBV_SITE)/$(FBV_SOURCE)

fbv-source: $(DL_DIR)/$(FBV_SOURCE)

$(FBV_DIR)/.unpacked: $(DL_DIR)/$(FBV_SOURCE)
	$(FBV_CAT) $(DL_DIR)/$(FBV_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(FBV_DIR) package/fbv/ fbv-$(FBV_VERSION)\*.patch\*
	touch $@

$(FBV_DIR)/.configured: $(FBV_DIR)/.unpacked
	(cd $(FBV_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--prefix=/usr \
		--cc=$(TARGET_CC) \
		--libs="-lz -lm" \
	);
	touch $@

$(FBV_DIR)/$(FBV_BINARY): $(FBV_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(FBV_DIR)

$(TARGET_DIR)/$(FBV_TARGET_BINARY): $(FBV_DIR)/$(FBV_BINARY)
	install -D $(FBV_DIR)/$(FBV_BINARY) $(TARGET_DIR)/$(FBV_TARGET_BINARY)

fbv: uclibc libpng jpeg libungif $(TARGET_DIR)/$(FBV_TARGET_BINARY)

fbv-clean:
	rm -f $(TARGET_DIR)/$(FBV_TARGET_BINARY)
	-$(MAKE) -C $(FBV_DIR) clean

fbv-dirclean:
	rm -rf $(FBV_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_FBV)),y)
TARGETS+=fbv
endif
