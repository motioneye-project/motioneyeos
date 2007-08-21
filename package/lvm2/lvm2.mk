#############################################################
#
# lvm2
#
#############################################################
# Copyright (C) 2005 by Richard Downer <rdowner@gmail.com>
# Derived from work
# Copyright (C) 2001-2005 by Erik Andersen <andersen@codepoet.org>
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

LVM2_BASEVER=2.02
LVM2_PATCH=26
LVM2_VERSION=$(LVM2_BASEVER).$(LVM2_PATCH)
LVM2_SOURCE:=LVM2.$(LVM2_VERSION).tgz
LVM2_SITE:=ftp://sources.redhat.com/pub/lvm2
LVM2_CAT:=$(ZCAT)
LVM2_DIR:=$(BUILD_DIR)/LVM2.$(LVM2_VERSION)
LVM2_SBIN:=lvchange lvcreate lvdisplay lvextend lvm lvmchange lvmdiskscan lvmsadc lvmsar lvreduce lvremove lvrename lvresize lvs lvscan pvchange pvcreate pvdisplay pvmove pvremove pvresize pvs pvscan vgcfgbackup vgcfgrestore vgchange vgck vgconvert vgcreate vgdisplay vgexport vgextend vgimport vgmerge vgmknodes vgreduce vgremove vgrename vgs vgscan vgsplit
LVM2_TARGET_SBINS=$(foreach lvm2sbin, $(LVM2_SBIN), $(TARGET_DIR)/sbin/$(lvm2sbin))

$(DL_DIR)/$(LVM2_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LVM2_SITE)/$(LVM2_SOURCE)

lvm2-source: $(DL_DIR)/$(LVM2_SOURCE)

$(LVM2_DIR)/.unpacked: $(DL_DIR)/$(LVM2_SOURCE)
	$(LVM2_CAT) $(DL_DIR)/$(LVM2_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(LVM2_DIR)/.unpacked

$(LVM2_DIR)/.configured: $(LVM2_DIR)/.unpacked
	(cd $(LVM2_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		ac_cv_have_decl_malloc=yes \
		gl_cv_func_malloc_0_nonnull=yes \
		ac_cv_func_malloc_0_nonnull=yes \
		ac_cv_func_calloc_0_nonnull=yes \
		ac_cv_func_realloc_0_nonnull=yes \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
		--with-user=$(shell id -un) --with-group=$(shell id -gn) \
	)
	touch $(LVM2_DIR)/.configured

$(LVM2_TARGET_SBINS): $(LVM2_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LVM2_DIR) DESTDIR=$(STAGING_DIR)
	$(MAKE) CC=$(TARGET_CC) -C $(LVM2_DIR) DESTDIR=$(STAGING_DIR) install
	for binary in $(LVM2_SBIN); do echo $$binary; cp -a $(STAGING_DIR)/sbin/$$binary $(TARGET_DIR)/sbin; done

lvm2: uclibc dm $(LVM2_TARGET_SBINS)

lvm2-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(LVM2_DIR) uninstall
	-$(MAKE) -C $(LVM2_DIR) clean

lvm2-dirclean:
	rm -rf $(LVM2_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LVM2)),y)
TARGETS+=lvm2
endif
