#############################################################
#
# libsysfs 
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

LIBSYSFS_VER:=1.2.0
LIBSYSFS_DIR:=$(BUILD_DIR)/sysfsutils-$(LIBSYSFS_VER)
LIBSYSFS_SITE:=http://cogent.dl.sourceforge.net/sourceforge/linux-diag
LIBSYSFS_SOURCE:=sysfsutils-$(LIBSYSFS_VER).tar.gz
LIBSYSFS_CAT:=zcat

$(DL_DIR)/$(LIBSYSFS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LIBSYSFS_SITE)/$(LIBSYSFS_SOURCE)

libsysfs-source: $(DL_DIR)/$(LIBSYSFS_SOURCE)

$(LIBSYSFS_DIR)/.unpacked: $(DL_DIR)/$(LIBSYSFS_SOURCE)
	$(LIBSYSFS_CAT) $(DL_DIR)/$(LIBSYSFS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(LIBSYSFS_DIR)/.unpacked

$(LIBSYSFS_DIR)/.configured: $(LIBSYSFS_DIR)/.unpacked
	(cd $(LIBSYSFS_DIR); \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS) " \
	./configure \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--prefix=/ );
	touch $(LIBSYSFS_DIR)/.configured

$(LIBSYSFS_DIR)/.compiled: $(LIBSYSFS_DIR)/.configured
	$(MAKE) -C $(LIBSYSFS_DIR)
	touch $(LIBSYSFS_DIR)/.compiled

$(STAGING_DIR)/lib/libsysfs.so: $(LIBSYSFS_DIR)/.compiled
	$(MAKE) -C $(LIBSYSFS_DIR) DESTDIR=$(STAGING_DIR) install
	touch -c $(STAGING_DIR)/lib/libsysfs.so

$(TARGET_DIR)/usr/lib/libsysfs.so: $(STAGING_DIR)/lib/libsysfs.so
	cp -dpf $(STAGING_DIR)/lib/libsysfs.so* $(TARGET_DIR)/usr/lib/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libsysfs.so

libsysfs: uclibc $(TARGET_DIR)/usr/lib/libsysfs.so

libsysfs-clean:
	-$(MAKE) -C $(LIBSYSFS_DIR) clean
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBSYSFS)),y)
TARGETS+=libsysfs
endif
