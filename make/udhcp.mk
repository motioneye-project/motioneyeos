#############################################################
#
# uchdp DHCP client and/or server
#
#############################################################
# Copyright (C) 2001, 2002 by Erik Andersen <andersen@codepoet.org>
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

UDHCP_SOURCE:=udhcp-0.9.8.tar.gz
UDHCP_SITE:=http://udhcp.busybox.net/downloads/
UDHCP_DIR:=$(BUILD_DIR)/udhcp-0.9.8

$(DL_DIR)/$(UDHCP_SOURCE):
	wget -P $(DL_DIR) $(UDHCP_SITE)/$(UDHCP_SOURCE)

udhcp-source: $(DL_DIR)/$(UDHCP_SOURCE)

$(UDHCP_DIR)/.unpacked: $(DL_DIR)/$(UDHCP_SOURCE)
	zcat $(DL_DIR)/$(UDHCP_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(UDHCP_DIR)/.unpacked

#$(UDHCP_DIR)/.unpacked: 
#	(cd $(BUILD_DIR); \
#	CVS_PASSFILE=$(CVS_PASSFILE) \
#	cvs -z3 -d:pserver:anonymous@busybox.net:/var/cvs co udhcp )
#	touch $(UDHCP_DIR)/.unpacked

$(UDHCP_DIR)/udhcpc: $(UDHCP_DIR)/.unpacked
	$(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" prefix="$(TARGET_DIR)" -C $(UDHCP_DIR)

$(TARGET_DIR)/sbin/udhcpc: $(UDHCP_DIR)/udhcpc
	cp $(UDHCP_DIR)/udhcpc $(TARGET_DIR)/sbin/

udhcp: uclibc $(TARGET_DIR)/sbin/udhcpc

udhcp-clean:
	rm -f $(TARGET_DIR)/sbin/udhcpc
	-$(MAKE) -C $(UDHCP_DIR) clean

udhcp-dirclean:
	rm -rf $(UDHCP_DIR)
