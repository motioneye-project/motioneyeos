#############################################################
#
# l2tp
#
#############################################################
L2TP_VER:=0.70-pre20031121
L2TP_SOURCE:=l2tpd_$(L2TP_VER).orig.tar.gz
L2TP_PATCH:=l2tpd_$(L2TP_VER)-2.1.diff.gz
L2TP_SITE:=ftp://ftp.debian.org/debian/pool/main/l/l2tpd/
L2TP_DIR:=$(BUILD_DIR)/l2tpd-$(L2TP_VER)
L2TP_CAT:=$(ZCAT)
L2TP_BINARY:=l2tpd
L2TP_TARGET_BINARY:=usr/sbin/l2tpd

$(DL_DIR)/$(L2TP_SOURCE):
	$(WGET) -P $(DL_DIR) $(L2TP_SITE)/$(L2TP_SOURCE)

$(DL_DIR)/$(L2TP_PATCH):
	$(WGET) -P $(DL_DIR) $(L2TP_SITE)/$(L2TP_PATCH)

l2tp-source: $(DL_DIR)/$(L2TP_SOURCE) $(DL_DIR)/$(L2TP_PATCH)

$(L2TP_DIR)/.unpacked: $(DL_DIR)/$(L2TP_SOURCE) $(DL_DIR)/$(L2TP_PATCH)
	$(L2TP_CAT) $(DL_DIR)/$(L2TP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	-mv -f $(L2TP_DIR).orig $(L2TP_DIR)
ifneq ($(L2TP_PATCH),)
	(cd $(L2TP_DIR) && $(L2TP_CAT) $(DL_DIR)/$(L2TP_PATCH) | patch -p1)
	if [ -d $(L2TP_DIR)/debian/patches ]; then \
		toolchain/patch-kernel.sh $(L2TP_DIR) $(L2TP_DIR)/debian/patches \*.patch ; \
	fi
endif
	toolchain/patch-kernel.sh $(L2TP_DIR) package/l2tp/ l2tp\*.patch
	touch $(L2TP_DIR)/.unpacked

$(L2TP_DIR)/$(L2TP_BINARY): $(L2TP_DIR)/.unpacked
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(L2TP_DIR) CC=$(TARGET_CC) \
		DFLAGS= \
		OSFLAGS="-DLINUX -UUSE_KERNEL $(TARGET_CFLAGS) -USANITY"

$(TARGET_DIR)/$(L2TP_TARGET_BINARY): $(L2TP_DIR)/$(L2TP_BINARY)
	cp -dpf $(L2TP_DIR)/$(L2TP_BINARY) $@
	cp -dpf package/l2tp/l2tpd $(TARGET_DIR)/etc/init.d/
	$(STRIP) $@

l2tp: uclibc $(TARGET_DIR)/$(L2TP_TARGET_BINARY)

l2tp-clean:
	-$(MAKE) -C $(L2TP_DIR) clean
	rm -f $(TARGET_DIR)/$(L2TP_TARGET_BINARY)

l2tp-dirclean:
	rm -rf $(L2TP_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_L2TP)),y)
TARGETS+=l2tp
endif
