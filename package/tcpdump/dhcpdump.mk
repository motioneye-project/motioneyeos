#############################################################
#
# dhcpdump
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

DHCPDUMP_VER:=1.4
DHCPDUMP_DIR:=$(BUILD_DIR)/dhcpdump-$(DHCPDUMP_VER)
DHCPDUMP_SITE:=http://www.mavetju.org/download/
DHCPDUMP_SOURCE:=dhcpdump-$(DHCPDUMP_VER).tar.gz
DHCPDUMP_CAT:=zcat

$(DL_DIR)/$(DHCPDUMP_SOURCE):
	 $(WGET) -P $(DL_DIR) $(DHCPDUMP_SITE)/$(DHCPDUMP_SOURCE)

dhcpdump-source: $(DL_DIR)/$(DHCPDUMP_SOURCE)

$(DHCPDUMP_DIR)/.unpacked: $(DL_DIR)/$(DHCPDUMP_SOURCE)
	$(DHCPDUMP_CAT) $(DL_DIR)/$(DHCPDUMP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(DHCPDUMP_DIR)/.unpacked

$(DHCPDUMP_DIR)/.configured: $(DHCPDUMP_DIR)/.unpacked
	( \
		cd $(DHCPDUMP_DIR) ; \
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
	touch $(DHCPDUMP_DIR)/.configured

$(DHCPDUMP_DIR)/dhcpdump: $(DHCPDUMP_DIR)/.configured
	$(MAKE) -C $(DHCPDUMP_DIR)

$(TARGET_DIR)/sbin/dhcpdump: $(DHCPDUMP_DIR)/dhcpdump
	cp -af $< $@

dhcpdump: uclibc zlib libpcap $(TARGET_DIR)/sbin/dhcpdump

dhcpdump-clean:
	rm -f $(TARGET_DIR)/sbin/dhcpdump
	-$(MAKE) -C $(DHCPDUMP_DIR) clean

dhcpdump-dirclean:
	rm -rf $(DHCPDUMP_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_DHCPDUMP)),y)
TARGETS+=dhcpdump
endif
