#############################################################
#
# Setserial
#
#############################################################
SETSERIAL_VERSION:=2.17
SETSERIAL_PATCH_VERSION:=-44
#SETSERIAL_PATCH_FILE:=
SETSERIAL_SOURCE:=setserial_$(SETSERIAL_VERSION)$(SETSERIAL_PATCH_VERSION).tar.gz
SETSERIAL_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/s/setserial/
SETSERIAL_DIR:=$(BUILD_DIR)/setserial-$(SETSERIAL_VERSION)
SETSERIAL_BINARY:=setserial
SETSERIAL_TARGET_BINARY:=usr/bin/setserial

$(DL_DIR)/$(SETSERIAL_SOURCE):
	$(WGET) -P $(DL_DIR) $(SETSERIAL_SITE)/$(SETSERIAL_SOURCE)

ifneq ($(SETSERIAL_PATCH_FILE),)
SETSERIAL_PATCH:=$(DL_DIR)/$(SETSERIAL_PATCH_FILE)
$(SETSERIAL_PATCH):
	$(WGET) -O $@ $(SETSERIAL_SITE)/$(SETSERIAL_PATCH_FILE)
else
SETSERIAL_PATCH:=
endif

$(SETSERIAL_DIR)/.unpacked: $(DL_DIR)/$(SETSERIAL_SOURCE) $(SETSERIAL_PATCH)
	$(ZCAT) $(DL_DIR)/$(SETSERIAL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(SETSERIAL_DIR)
	toolchain/patch-kernel.sh $(SETSERIAL_DIR) package/setserial setserial\*.patch
ifneq ($(SETSERIAL_PATCH_FILE),)
	toolchain/patch-kernel.sh $(SETSERIAL_DIR) $(DL_DIR) $(SETSERIAL_PATCH_FILE)
	if [ -d $(SETSERIAL_DIR)/debian/patches ]; then \
		toolchain/patch-kernel.sh $(SETSERIAL_DIR) $(SETSERIAL_DIR)/debian/patches \*.patch; \
	fi
endif
	touch $(SETSERIAL_DIR)/gorhack.h
	touch $@

ifeq ($(BR2_PREFER_IMA),y)
SETSERIAL_CFLAGS=$(CFLAGS_COMBINE) $(CFLAGS_WHOLE_PROGRAM)
endif

$(SETSERIAL_DIR)/.configured: $(SETSERIAL_DIR)/.unpacked
	(cd $(SETSERIAL_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CFLAGS="$(TARGET_CFLAGS) $(SETSERIAL_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
	)
	touch $@

$(SETSERIAL_DIR)/$(SETSERIAL_BINARY): $(SETSERIAL_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(SETSERIAL_DIR)

$(TARGET_DIR)/$(SETSERIAL_TARGET_BINARY): $(SETSERIAL_DIR)/$(SETSERIAL_BINARY)
	install -c $(SETSERIAL_DIR)/$(SETSERIAL_BINARY) $(TARGET_DIR)/$(SETSERIAL_TARGET_BINARY)
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/$(SETSERIAL_TARGET_BINARY)

setserial: uclibc $(TARGET_DIR)/$(SETSERIAL_TARGET_BINARY)

setserial-source: $(DL_DIR)/$(SETSERIAL_SOURCE) $(SETSERIAL_PATCH)

setserial-clean:
	rm -f $(TARGET_DIR)/$(SETSERIAL_TARGET_BINARY)
	-$(MAKE) -C $(SETSERIAL_DIR) clean

setserial-dirclean:
	rm -rf $(SETSERIAL_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_SETSERIAL)),y)
TARGETS+=setserial
endif
