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

LIBSYSFS_VERSION:=2.1.0
LIBSYSFS_DIR:=$(BUILD_DIR)/sysfsutils-$(LIBSYSFS_VERSION)
LIBSYSFS_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/linux-diag
LIBSYSFS_SOURCE:=sysfsutils-$(LIBSYSFS_VERSION).tar.gz
LIBSYSFS_CAT:=$(ZCAT)

$(DL_DIR)/$(LIBSYSFS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LIBSYSFS_SITE)/$(LIBSYSFS_SOURCE)

libsysfs-source: $(DL_DIR)/$(LIBSYSFS_SOURCE)

$(LIBSYSFS_DIR)/.unpacked: $(DL_DIR)/$(LIBSYSFS_SOURCE)
	$(LIBSYSFS_CAT) $(DL_DIR)/$(LIBSYSFS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(@D)
	touch $@

$(LIBSYSFS_DIR)/.configured: $(LIBSYSFS_DIR)/.unpacked
	(cd $(LIBSYSFS_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
	)
	touch $@

$(LIBSYSFS_DIR)/.compiled: $(LIBSYSFS_DIR)/.configured
	$(MAKE) -C $(LIBSYSFS_DIR)
	touch $@

$(STAGING_DIR)/usr/lib/libsysfs.so: $(LIBSYSFS_DIR)/.compiled
	$(MAKE) -C $(LIBSYSFS_DIR) DESTDIR=$(STAGING_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" \
		$(STAGING_DIR)/usr/lib/libsysfs.la
	touch -c $@

$(TARGET_DIR)/usr/lib/libsysfs.so: $(STAGING_DIR)/usr/lib/libsysfs.so
	cp -dpf $(STAGING_DIR)/usr/lib/libsysfs.so* $(TARGET_DIR)/usr/lib/
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libsysfs.so

libsysfs: uclibc $(TARGET_DIR)/usr/lib/libsysfs.so

libsysfs-clean:
	-$(MAKE) -C $(LIBSYSFS_DIR) clean
	-$(MAKE) -C $(LIBSYSFS_DIR) DESTDIR=$(STAGING_DIR) uninstall
	rm -f $(TARGET_DIR)/usr/lib/libsysfs.so*

libsysfs-dirclean:
	rm -rf $(LIBSYSFS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBSYSFS)),y)
TARGETS+=libsysfs
endif
