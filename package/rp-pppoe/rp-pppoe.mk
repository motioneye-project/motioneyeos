#############################################################
#
# rp-pppoe
#
#############################################################
RP_PPPOE_VERSION:=3.8
RP_PPPOE_SOURCE:=rp-pppoe_$(RP_PPPOE_VERSION).orig.tar.gz
RP_PPPOE_PATCH:=rp-pppoe_$(RP_PPPOE_VERSION)-3.diff.gz
RP_PPPOE_SITE:=ftp://ftp.debian.org/debian/pool/main/r/rp-pppoe
RP_PPPOE_TOPDIR:=$(BUILD_DIR)/rp-pppoe-$(RP_PPPOE_VERSION)
RP_PPPOE_DIR:=$(BUILD_DIR)/rp-pppoe-$(RP_PPPOE_VERSION)/src
RP_PPPOE_CAT:=$(ZCAT)
RP_PPPOE_BINARY:=pppoe
RP_PPPOE_TARGET_BINARY:=usr/sbin/pppoe

$(DL_DIR)/$(RP_PPPOE_SOURCE):
	$(WGET) -P $(DL_DIR) $(RP_PPPOE_SITE)/$(RP_PPPOE_SOURCE)

ifneq ($(RP_PPPOE_PATCH),)
RP_PPPOE_PATCH_FILE:=$(DL_DIR)/$(RP_PPPOE_PATCH)
$(RP_PPPOE_PATCH_FILE):
	$(WGET) -P $(DL_DIR) $(RP_PPPOE_SITE)/$(RP_PPPOE_PATCH)
endif

$(RP_PPPOE_TOPDIR)/.unpacked: $(DL_DIR)/$(RP_PPPOE_SOURCE) $(RP_PPPOE_PATCH_FILE)
	$(RP_PPPOE_CAT) $(DL_DIR)/$(RP_PPPOE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
ifneq ($(RP_PPPOE_PATCH),)
	(cd $(RP_PPPOE_TOPDIR) && $(RP_PPPOE_CAT) $(DL_DIR)/$(RP_PPPOE_PATCH) | patch -p1)
	if [ -d $(RP_PPPOE_TOPDIR)/debian/patches ]; then \
		toolchain/patch-kernel.sh $(RP_PPPOE_TOPDIR) $(RP_PPPOE_TOPDIR)/debian/patches \*.patch; \
	fi
endif
	toolchain/patch-kernel.sh $(RP_PPPOE_TOPDIR) package/rp-pppoe/ rp-pppoe\*.patch
	touch $@

$(RP_PPPOE_TOPDIR)/.configured: $(RP_PPPOE_TOPDIR)/.unpacked
	(cd $(RP_PPPOE_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		rpppoe_cv_pack_bitfields=normal \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		$(DISABLE_LARGEFILE) \
		--disable-debugging \
	)
	touch $@

$(RP_PPPOE_DIR)/$(RP_PPPOE_BINARY): $(RP_PPPOE_TOPDIR)/.configured
	$(MAKE) -C $(RP_PPPOE_DIR)

$(TARGET_DIR)/$(RP_PPPOE_TARGET_BINARY): $(RP_PPPOE_DIR)/$(RP_PPPOE_BINARY)
	cp -dpf $(RP_PPPOE_DIR)/$(RP_PPPOE_BINARY) $@
ifeq ($(BR2_HAVE_MANPAGES),y)
	mkdir -p $(TARGET_DIR)/usr/share/man/man8
	$(INSTALL) -m 644 $(RP_PPPOE_TOPDIR)/man/pppoe.8 $(TARGET_DIR)/usr/share/man/man8/pppoe.8
endif
	$(STRIPCMD) $(STRIP_STRIP_ALL) $@

rp-pppoe: uclibc $(TARGET_DIR)/$(RP_PPPOE_TARGET_BINARY)

rp-pppoe-source: $(DL_DIR)/$(RP_PPPOE_SOURCE) $(RP_PPPOE_PATCH_FILE)

rp-pppoe-clean:
	-$(MAKE) -C $(RP_PPPOE_DIR) clean
	rm -f $(TARGET_DIR)/$(RP_PPPOE_TARGET_BINARY) \
		$(TARGET_DIR)/usr/share/man/man8/pppoe.8*

rp-pppoe-dirclean:
	rm -rf $(RP_PPPOE_TOPDIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_RP_PPPOE)),y)
TARGETS+=rp-pppoe
endif
