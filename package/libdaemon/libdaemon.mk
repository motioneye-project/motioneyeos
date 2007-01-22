#############################################################
#
# libdaemon (UNIX daemon library)
#
#############################################################
# Copyright 2003-2005 Lennart Poettering <mzqnrzba@0pointer.de>
#
# This library is free software; you can redistribute it 
# and/or modify it under the terms of the GNU Lesser General 
# Public License as published by the Free Software Foundation; 
# either version 2.1 of the License, or (at your option) any 
# later version.

LIBDAEMON_VER:=0.10
LIBDAEMON_DIR:=$(BUILD_DIR)/libdaemon-$(LIBDAEMON_VER)
LIBDAEMON_SITE:=http://0pointer.de/lennart/projects/libdaemon/
LIBDAEMON_SOURCE:=libdaemon-$(LIBDAEMON_VER).tar.gz
LIBDAEMON_CAT:=$(ZCAT)

$(DL_DIR)/$(LIBDAEMON_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LIBDAEMON_SITE)/$(LIBDAEMON_SOURCE)

libdaemon-source: $(DL_DIR)/$(LIBDAEMON_SOURCE)

$(LIBDAEMON_DIR)/.unpacked: $(DL_DIR)/$(LIBDAEMON_SOURCE)
	$(LIBDAEMON_CAT) $(DL_DIR)/$(LIBDAEMON_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBDAEMON_DIR) package/libdaemon/ \*.patch
	touch $(LIBDAEMON_DIR)/.unpacked

$(LIBDAEMON_DIR)/.configured: $(LIBDAEMON_DIR)/.unpacked
	(cd $(LIBDAEMON_DIR) && rm -rf config.cache && autoconf)
	( \
		cd $(LIBDAEMON_DIR) && \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
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
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
		--disable-lynx \
		--disable-shared \
	);
	touch $(LIBDAEMON_DIR)/.configured

$(LIBDAEMON_DIR)/.compiled: $(LIBDAEMON_DIR)/.configured
	$(MAKE) -C $(LIBDAEMON_DIR)
	touch $(LIBDAEMON_DIR)/.compiled

$(STAGING_DIR)/lib/libdaemon.a: $(LIBDAEMON_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBDAEMON_DIR) install
	touch -c $(STAGING_DIR)/lib/libdaemon.a

#$(TARGET_DIR)/usr/lib/libdaemon.a: $(STAGING_DIR)/lib/libdaemon.a
#	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libdaemon.a

libdaemon: uclibc pkgconfig $(STAGING_DIR)/lib/libdaemon.a

libdaemon-clean:
	-$(MAKE) -C $(LIBDAEMON_DIR) clean

libdaemon-dirclean:
	rm -rf $(LIBDAEMON_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBDAEMON)),y)
TARGETS+=libdaemon
endif
