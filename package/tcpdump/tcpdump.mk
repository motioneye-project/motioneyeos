#############################################################
#
# tcpdump 
#
#############################################################
# Copyright (C) 2001-2003 by Erik Andersen <andersen@codepoet.org>
# Copyright (C) 2002 by Tim Riker <Tim@Rikers.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Library General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Library General Public License for more details.
#
# You should have received a copy of the GNU Library General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
# USA

TCPDUMP_VER:=3.8.3
TCPDUMP_DIR:=$(BUILD_DIR)/tcpdump-$(TCPDUMP_VER)
TCPDUMP_SITE:=http://www.tcpdump.org/release
TCPDUMP_SOURCE:=tcpdump-$(TCPDUMP_VER).tar.gz
TCPDUMP_CAT:=zcat

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
		BUILD_CC=$(TARGET_CC) HOSTCC=$(HOSTCC) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--with-build-cc=$(HOSTCC) \
		--prefix=$(STAGING_DIR) \
		--libdir=$(STAGING_DIR)/lib \
		--includedir=$(STAGING_DIR)/include \
	)
	$(SED) '/HAVE_PCAP_DEBUG/d' $(TCPDUMP_DIR)/config.h
	touch $(TCPDUMP_DIR)/.configured

$(TCPDUMP_DIR)/tcpdump: $(TCPDUMP_DIR)/.configured
	$(MAKE) \
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
