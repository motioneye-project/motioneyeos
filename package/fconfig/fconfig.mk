#############################################################
#
# fconfig
#
#############################################################
FCONFIG_VERSION:=20060419
FCONFIG_SOURCE:=fconfig-$(FCONFIG_VERSION).tar.gz
FCONFIG_SITE:=http://andrzejekiert.ovh.org/software/fconfig/
FCONFIG_CAT:=$(ZCAT)
FCONFIG_DIR:=$(BUILD_DIR)/fconfig
FCONFIG_BINARY:=fconfig
FCONFIG_TARGET_BINARY:=sbin/fconfig

$(DL_DIR)/$(FCONFIG_SOURCE):
	 $(WGET) -P $(DL_DIR) $(FCONFIG_SITE)/$(FCONFIG_SOURCE)

fconfig-source: $(DL_DIR)/$(FCONFIG_SOURCE)

$(FCONFIG_DIR)/.unpacked: $(DL_DIR)/$(FCONFIG_SOURCE)
	$(FCONFIG_CAT) $(DL_DIR)/$(FCONFIG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(FCONFIG_DIR) package/fconfig \*.patch
	touch $@

$(FCONFIG_DIR)/$(FCONFIG_BINARY): $(FCONFIG_DIR)/.unpacked
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(FCONFIG_DIR) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)"

$(TARGET_DIR)/$(FCONFIG_TARGET_BINARY): $(FCONFIG_DIR)/$(FCONFIG_BINARY)
	rm -f $(TARGET_DIR)/$(FCONFIG_TARGET_BINARY)
	$(INSTALL) -D -m 0755 $(FCONFIG_DIR)/$(FCONFIG_BINARY) $(TARGET_DIR)/$(FCONFIG_TARGET_BINARY)
	$(STRIPCMD) $(STRIP_STRIP_ALL) $@

fconfig: uclibc $(TARGET_DIR)/$(FCONFIG_TARGET_BINARY)

fconfig-clean:
	-$(MAKE) -C $(FCONFIG_DIR) clean
	rm -f $(TARGET_DIR)/$(FCONFIG_TARGET_BINARY)

fconfig-dirclean:
	rm -rf $(FCONFIG_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_FCONFIG)),y)
TARGETS+=fconfig
endif
