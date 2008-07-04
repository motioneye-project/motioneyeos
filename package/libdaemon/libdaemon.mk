#############################################################
#
# libdaemon (UNIX daemon library)
#
#############################################################
# Copyright 2003-2005 Lennart Poettering <mzqnrzba@0pointer.de>
#
# This library is free software; you can redistribute it
# and/or modify it under the terms of the GNU Lesser General
# Public License as published by the Free Software Foundation
# either version 2.1 of the License, or (at your option) any
# later version.

LIBDAEMON_VERSION:=0.12
LIBDAEMON_NAME:=libdaemon-$(LIBDAEMON_VERSION)
LIBDAEMON_DIR:=$(BUILD_DIR)/$(LIBDAEMON_NAME)
LIBDAEMON_SITE:=http://0pointer.de/lennart/projects/libdaemon/
LIBDAEMON_SOURCE:=$(LIBDAEMON_NAME).tar.gz
LIBDAEMON_DESTDIR:=$(STAGING_DIR)/usr/lib
LIBDAEMON_CAT:=$(ZCAT)

$(DL_DIR)/$(LIBDAEMON_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LIBDAEMON_SITE)/$(LIBDAEMON_SOURCE)

libdaemon-source: $(DL_DIR)/$(LIBDAEMON_SOURCE)

libdaemon-unpacked: $(LIBDAEMON_DIR)/.unpacked
$(LIBDAEMON_DIR)/.unpacked: $(DL_DIR)/$(LIBDAEMON_SOURCE)
	$(LIBDAEMON_CAT) $(DL_DIR)/$(LIBDAEMON_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBDAEMON_DIR) package/libdaemon/ \*.patch
	touch $@

libdaemon-configured: $(LIBDAEMON_DIR)/.configured
$(LIBDAEMON_DIR)/.configured: $(LIBDAEMON_DIR)/.unpacked
	(cd $(LIBDAEMON_DIR) && rm -rf config.cache && libtoolize --copy --force && autoreconf)
	$(CONFIG_UPDATE) $(LIBDAEMON_DIR)
	(cd $(LIBDAEMON_DIR) && \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/usr/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/usr/include \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
		--disable-lynx \
		--disable-shared \
	)
	touch $@

$(LIBDAEMON_DIR)/.compiled: $(LIBDAEMON_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) LIBTOOL=$(LIBDAEMON_DIR)/libtool -C $(LIBDAEMON_DIR)
	touch $@

$(LIBDAEMON_DESTDIR)/libdaemon.a: $(LIBDAEMON_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBDAEMON_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/lib/libdaemon.la
	touch -c $@

#$(TARGET_DIR)/usr/lib/libdaemon.a: $(LIBDAEMON_DESTDIR)/libdaemon.a
# -$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libdaemon.a

libdaemon: uclibc pkgconfig $(LIBDAEMON_DESTDIR)/libdaemon.a

libdaemon-unpacked: $(LIBDAEMON_DIR)/.unpacked

libdaemon-clean:
	-$(MAKE) -C $(LIBDAEMON_DIR) clean

libdaemon-patch-prep: libdaemon-dirclean libdaemon-unpacked
	cp -af $(LIBDAEMON_DIR) $(LIBDAEMON_DIR)-0rig

libdaemon-patch:
	(cd $(BUILD_DIR); \
	diff -urN $(LIBDAEMON_NAME)-0rig $(LIBDAEMON_NAME) > ../../$(LIBDAEMON_NAME)-$(DATE).patch || echo)

libdaemon-dirclean:
	rm -rf $(LIBDAEMON_DIR)
	rm -rf $(LIBDAEMON_DIR)-0rig

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBDAEMON)),y)
TARGETS+=libdaemon
endif
