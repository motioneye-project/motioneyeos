#############################################################
#
# netkitbase
#
#############################################################
NETKITBASE_VERSION:=0.17
NETKITBASE_SOURCE:=netkit-base-$(NETKITBASE_VERSION).tar.gz
NETKITBASE_SITE:=ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/
NETKITBASE_DIR:=$(BUILD_DIR)/netkit-base-$(NETKITBASE_VERSION)
NETKITBASE_CAT:=$(ZCAT)
NETKITBASE_BINARY:=inetd/inetd
NETKITBASE_TARGET_BINARY:=usr/sbin/inetd

$(DL_DIR)/$(NETKITBASE_SOURCE):
	 $(WGET) -P $(DL_DIR) $(NETKITBASE_SITE)/$(NETKITBASE_SOURCE)

netkitbase-source: $(DL_DIR)/$(NETKITBASE_SOURCE)

$(NETKITBASE_DIR)/.unpacked: $(DL_DIR)/$(NETKITBASE_SOURCE)
	$(NETKITBASE_CAT) $(DL_DIR)/$(NETKITBASE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	# use ANSI syntax
	$(SED) "s/main()/main(void)/;" $(NETKITBASE_DIR)/configure
	# don't try to run cross compiled binaries while configuring things
	$(SED) "s~./__conftest~#./__conftest~;" $(NETKITBASE_DIR)/configure
	toolchain/patch-kernel.sh $(NETKITBASE_DIR) package/netkitbase/ netkitbase\*.patch
	touch $(NETKITBASE_DIR)/.unpacked

$(NETKITBASE_DIR)/.configured: $(NETKITBASE_DIR)/.unpacked
	(cd $(NETKITBASE_DIR); PATH=$(TARGET_PATH) CC=$(TARGET_CC) \
		./configure --installroot=$(TARGET_DIR) --with-c-compiler=$(TARGET_CC) \
	)
	touch $(NETKITBASE_DIR)/.configured

$(NETKITBASE_DIR)/$(NETKITBASE_BINARY): $(NETKITBASE_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(NETKITBASE_DIR)
	$(STRIP) $(NETKITBASE_DIR)/$(NETKITBASE_BINARY)

$(TARGET_DIR)/$(NETKITBASE_TARGET_BINARY): $(NETKITBASE_DIR)/$(NETKITBASE_BINARY)
	# Only install a few selected items...
	mkdir -p $(TARGET_DIR)/usr/sbin
	cp $(NETKITBASE_DIR)/$(NETKITBASE_BINARY) $(TARGET_DIR)/$(NETKITBASE_TARGET_BINARY)
	@if [ ! -f $(TARGET_DIR)/etc/inetd.conf ] ; then \
		mkdir -p $(TARGET_DIR)/etc; \
		cp $(NETKITBASE_DIR)/etc.sample/inetd.conf $(TARGET_DIR)/etc/; \
		$(SED) "s/^\([a-z]\)/#\1/;" $(TARGET_DIR)/etc/inetd.conf; \
	fi
	touch -c $(TARGET_DIR)/$(NETKITBASE_TARGET_BINARY)

netkitbase: uclibc $(TARGET_DIR)/$(NETKITBASE_TARGET_BINARY)

netkitbase-clean:
	#$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(NETKITBASE_DIR) uninstall
	-rm -f $(TARGET_DIR)/usr/sbin/inetd $(TARGET_DIR)/etc/inetd.conf
	-rm -f $(TARGET_DIR)/etc/inetd.conf
	-$(MAKE) -C $(NETKITBASE_DIR) clean

netkitbase-dirclean:
	rm -rf $(NETKITBASE_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_NETKITBASE)),y)
TARGETS+=netkitbase
endif
