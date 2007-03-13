#############################################################
#
# tcpdump 
#
#############################################################
# Copyright (C) 2001-2003 by Erik Andersen <andersen@codepoet.org>
# Copyright (C) 2002 by Tim Riker <Tim@Rikers.org>

TCPDUMP_VER:=3.9.4
TCPDUMP_DIR:=$(BUILD_DIR)/tcpdump-$(TCPDUMP_VER)
TCPDUMP_SITE:=http://www.tcpdump.org/release
TCPDUMP_SOURCE:=tcpdump-$(TCPDUMP_VER).tar.gz
TCPDUMP_CAT:=$(ZCAT)

$(DL_DIR)/$(TCPDUMP_SOURCE):
	 $(WGET) -P $(DL_DIR) $(TCPDUMP_SITE)/$(TCPDUMP_SOURCE)

tcpdump-source: $(DL_DIR)/$(TCPDUMP_SOURCE)

$(TCPDUMP_DIR)/.unpacked: $(DL_DIR)/$(TCPDUMP_SOURCE)
	$(TCPDUMP_CAT) $(DL_DIR)/$(TCPDUMP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(TCPDUMP_DIR)/.unpacked

$(TCPDUMP_DIR)/.configured: $(TCPDUMP_DIR)/.unpacked
	( \
		cd $(TCPDUMP_DIR) ; \
		ac_cv_linux_vers=$(BR2_DEFAULT_KERNEL_HEADERS) \
		BUILD_CC=$(TARGET_CC) HOSTCC="$(HOSTCC)" \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)"
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--with-build-cc="$(HOSTCC)" \
		--without-crypto \
	)
	$(SED) '/HAVE_PCAP_DEBUG/d' $(TCPDUMP_DIR)/config.h
	touch $(TCPDUMP_DIR)/.configured

$(TCPDUMP_DIR)/tcpdump: $(TCPDUMP_DIR)/.configured
	$(MAKE) CC="$(TARGET_CC)" \
		LDFLAGS="-L$(STAGING_DIR)/lib" \
		LIBS="-lpcap" \
		INCLS="-I. -I$(STAGING_DIR)/include" \
		-C $(TCPDUMP_DIR)

$(TARGET_DIR)/sbin/tcpdump: $(TCPDUMP_DIR)/tcpdump
	cp -af $< $@

tcpdump: uclibc zlib libpcap $(TARGET_DIR)/sbin/tcpdump

tcpdump-clean:
	rm -f $(TARGET_DIR)/sbin/tcpdump
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
