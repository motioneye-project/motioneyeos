#############################################################
#
# nbd (client only)
#
#############################################################

NBD_VERSION=2.9.11
NBD_SOURCE=nbd-$(NBD_VERSION).tar.bz2
NBD_CAT:=$(BZCAT)
NBD_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/nbd/
NBD_DIR=$(BUILD_DIR)/nbd-$(NBD_VERSION)

ifeq ($(BR2_NBD_CLIENT),y)
NBD_TARGET_BINARY+= $(TARGET_DIR)/sbin/nbd-client
endif
ifeq ($(BR2_NBD_SERVER),y)
NBD_TARGET_BINARY+= $(TARGET_DIR)/bin/nbd-server
endif

$(DL_DIR)/$(NBD_SOURCE):
	$(call DOWNLOAD,$(NBD_SITE),$(NBD_SOURCE))

$(NBD_DIR)/.unpacked: $(DL_DIR)/$(NBD_SOURCE)
	$(NBD_CAT) $(DL_DIR)/$(NBD_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(NBD_DIR)/.patched: $(NBD_DIR)/.unpacked
	toolchain/patch-kernel.sh $(NBD_DIR) package/nbd/ nbd\*.patch
	touch $@

$(NBD_DIR)/.configured: $(NBD_DIR)/.patched
	(cd $(NBD_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CC=$(TARGET_CC) \
		./configure $(QUIET) \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		$(if $(BR2_LARGEFILE),--enable-lfs,--disable-lfs) \
	)
	touch $@

$(NBD_DIR)/nbd-client: $(NBD_DIR)/.configured
	$(MAKE) -C $(NBD_DIR) nbd-client

$(TARGET_DIR)/sbin/nbd-client: $(NBD_DIR)/nbd-client
	cp $< $@
	$(STRIPCMD) $@

$(NBD_DIR)/nbd-server: $(NBD_DIR)/.configured
	$(MAKE) -C $(NBD_DIR) nbd-server

$(TARGET_DIR)/bin/nbd-server: $(NBD_DIR)/nbd-server
	cp $< $@
	$(STRIPCMD) $@

nbd: libglib2 $(NBD_TARGET_BINARY)

nbd-source: $(DL_DIR)/$(NBD_SOURCE)

nbd-clean:
	rm -f $(NBD_TARGET_BINARY)
	-$(MAKE) -C $(NBD_DIR) clean

nbd-dirclean:
	rm -rf $(NBD_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_NBD),y)
TARGETS+=nbd
endif
