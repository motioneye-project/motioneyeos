#############################################################
#
# libcgicc
#
#############################################################

LIBCGICC_VERSION=3.2.7
LIBCGICC_DIR=$(BUILD_DIR)/cgicc-$(LIBCGICC_VERSION)
LIBCGICC_SITE=$(BR2_GNU_MIRROR)/cgicc
LIBCGICC_SOURCE=cgicc-$(LIBCGICC_VERSION).tar.gz
LIBCGICC_CAT:=$(ZCAT)

$(DL_DIR)/$(LIBCGICC_SOURCE):
	$(call DOWNLOAD,$(LIBCGICC_SITE),$(LIBCGICC_SOURCE))

libcgicc-source: $(DL_DIR)/$(LIBCGICC_SOURCE)

$(LIBCGICC_DIR)/.unpacked: $(DL_DIR)/$(LIBCGICC_SOURCE)
	$(LIBCGICC_CAT) $(DL_DIR)/$(LIBCGICC_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBCGICC_DIR) package/libcgicc cgicc\*.patch
	touch $@

$(LIBCGICC_DIR)/.configured: $(LIBCGICC_DIR)/.unpacked
	(cd $(LIBCGICC_DIR); rm -f config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--disable-demos \
	)
	touch $@

$(LIBCGICC_DIR)/.compiled: $(LIBCGICC_DIR)/.configured
	$(MAKE) -C $(LIBCGICC_DIR)
	touch $@

$(STAGING_DIR)/usr/lib/libcgicc.so: $(LIBCGICC_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBCGICC_DIR) install
	touch -c $(STAGING_DIR)/usr/lib/libcgicc.so

$(TARGET_DIR)/usr/lib/libcgicc.so: $(STAGING_DIR)/usr/lib/libcgicc.so
	cp -dpf $(STAGING_DIR)/usr/lib/libcgicc.so* $(TARGET_DIR)/usr/lib/

libcgicc: uclibc $(TARGET_DIR)/usr/lib/libcgicc.so

libcgicc-unpacked: $(LIBCGICC_DIR)/.unpacked

libcgicc-clean:
		-$(MAKE) -C $(LIBCGICC_DIR) clean

libcgicc-dirclean:
	rm -rf $(LIBCGICC_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_LIBCGICC),y)
TARGETS+=libcgicc
endif
