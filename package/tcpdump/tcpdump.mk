#############################################################
#
# tcpdump
#
#############################################################
# Copyright (C) 2001-2003 by Erik Andersen <andersen@codepoet.org>
# Copyright (C) 2002 by Tim Riker <Tim@Rikers.org>

TCPDUMP_VERSION:=3.9.5
TCPDUMP_DIR:=$(BUILD_DIR)/tcpdump-$(TCPDUMP_VERSION)
TCPDUMP_SITE:=http://www.tcpdump.org/release
TCPDUMP_SOURCE:=tcpdump-$(TCPDUMP_VERSION).tar.gz
TCPDUMP_CAT:=$(ZCAT)

$(DL_DIR)/$(TCPDUMP_SOURCE):
	 $(WGET) -P $(DL_DIR) $(TCPDUMP_SITE)/$(TCPDUMP_SOURCE)

tcpdump-source: $(DL_DIR)/$(TCPDUMP_SOURCE)

$(TCPDUMP_DIR)/.unpacked: $(DL_DIR)/$(TCPDUMP_SOURCE)
	$(TCPDUMP_CAT) $(DL_DIR)/$(TCPDUMP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(TCPDUMP_DIR) package/tcpdump tcpdump\*.patch
	touch $@

$(TCPDUMP_DIR)/.configured: $(TCPDUMP_DIR)/.unpacked
	( \
		cd $(TCPDUMP_DIR); \
		ac_cv_linux_vers=$(BR2_DEFAULT_KERNEL_HEADERS) \
		BUILD_CC=$(TARGET_CC) HOSTCC="$(HOSTCC)" \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--without-crypto \
		--disable-smb \
	)
	$(SED) '/HAVE_PCAP_DEBUG/d' $(TCPDUMP_DIR)/config.h
	touch $@

$(TCPDUMP_DIR)/tcpdump: $(TCPDUMP_DIR)/.configured
	$(MAKE) CC="$(TARGET_CC)" \
		LDFLAGS="-L$(STAGING_DIR)/usr/lib" \
		LIBS="-lpcap" \
		INCLS="-I. -I$(STAGING_DIR)/usr/include" \
		-C $(TCPDUMP_DIR)

$(TARGET_DIR)/usr/sbin/tcpdump: $(TCPDUMP_DIR)/tcpdump
	cp -f $< $@
	$(STRIP) $@

tcpdump: uclibc zlib libpcap $(TARGET_DIR)/usr/sbin/tcpdump

tcpdump-clean:
	rm -f $(TARGET_DIR)/usr/sbin/tcpdump
	-$(MAKE) -C $(TCPDUMP_DIR) clean

tcpdump-dirclean:
	rm -rf $(TCPDUMP_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_TCPDUMP)),y)
TARGETS+=tcpdump
endif
