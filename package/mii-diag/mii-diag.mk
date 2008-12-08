#############################################################
#
# mii-diag
#
#############################################################
MIIDIAG_VERSION:=2.11
MIIDIAG_DEBIAN_PATCH_LEVEL:=2
MIIDIAG_SOURCE:=mii-diag_$(MIIDIAG_VERSION).orig.tar.gz
MIIDIAG_PATCH_FILE=mii-diag_$(MIIDIAG_VERSION)-$(MIIDIAG_DEBIAN_PATCH_LEVEL).diff.gz
MIIDIAG_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/m/mii-diag
MIIDIAG_DIR:=$(BUILD_DIR)/mii-diag-$(MIIDIAG_VERSION)
MIIDIAG_CAT:=$(ZCAT)
MIIDIAG_BINARY:=usr/sbin/mii-diag

ifneq ($(MIIDIAG_PATCH_FILE),)
MIIDIAG_PATCH=$(DL_DIR)/$(MIIDIAG_PATCH_FILE)
$(MIIDIAG_PATCH):
	$(WGET) -P $(DL_DIR) $(MIIDIAG_SITE)/$(MIIDIAG_PATCH_FILE)
endif

$(DL_DIR)/$(MIIDIAG_SOURCE):
	$(WGET) -P $(DL_DIR) $(MIIDIAG_SITE)/$(MIIDIAG_SOURCE)

$(MIIDIAG_DIR)/.unpacked: $(DL_DIR)/$(MIIDIAG_SOURCE) $(MIIDIAG_PATCH)
	mkdir -p $(MIIDIAG_DIR)
	$(MIIDIAG_CAT) $(DL_DIR)/$(MIIDIAG_SOURCE) | tar --strip 1 -C $(MIIDIAG_DIR) $(TAR_OPTIONS) -
ifneq ($(MIIDIAG_PATCH_FILE),)
	(cd $(MIIDIAG_DIR) && $(MIIDIAG_CAT) $(MIIDIAG_PATCH) | patch -p1)
endif
	toolchain/patch-kernel.sh $(MIIDIAG_DIR) package/mii-diag/ mii-diag-\*.patch*
	touch $@

$(MIIDIAG_DIR)/.configured: $(MIIDIAG_DIR)/.unpacked
	touch $@

$(MIIDIAG_DIR)/mii-diag: $(MIIDIAG_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" -C $(MIIDIAG_DIR)

$(TARGET_DIR)/$(MIIDIAG_BINARY): $(MIIDIAG_DIR)/mii-diag
	$(MAKE) CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" -C $(MIIDIAG_DIR) DESTDIR=$(TARGET_DIR) install
	$(STRIPCMD) $@
	touch $@

mii-diag: uclibc $(TARGET_DIR)/$(MIIDIAG_BINARY)

mii-diag-source: $(DL_DIR)/$(MIIDIAG_SOURCE) $(MIIDIAG_PATCH)

mii-diag-clean:
	-$(MAKE) -C $(MIIDIAG_DIR) clean

mii-diag-dirclean:
	rm -rf $(MIIDIAG_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_MIIDIAG),y)
TARGETS+=mii-diag
endif
