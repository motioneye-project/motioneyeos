#############################################################
#
# jpeg (libraries needed by some apps)
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
JPEG_VERSION:=6b
JPEG_DIR=$(BUILD_DIR)/jpeg-$(JPEG_VERSION)
JPEG_SITE:=ftp://ftp.uu.net/graphics/jpeg/
JPEG_SOURCE=jpegsrc.v$(JPEG_VERSION).tar.gz
JPEG_CAT:=$(ZCAT)

$(DL_DIR)/$(JPEG_SOURCE):
	 $(WGET) -P $(DL_DIR) $(JPEG_SITE)/$(JPEG_SOURCE)

jpeg-source: $(DL_DIR)/$(JPEG_SOURCE)

$(JPEG_DIR)/.unpacked: $(DL_DIR)/$(JPEG_SOURCE)
	$(JPEG_CAT) $(DL_DIR)/$(JPEG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(JPEG_DIR) package/jpeg/ jpeg\*.patch
	$(CONFIG_UPDATE) $(JPEG_DIR)
	touch $@

$(JPEG_DIR)/.configured: $(JPEG_DIR)/.unpacked
	(cd $(JPEG_DIR); rm -rf config.cache; \
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
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/usr/include \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--enable-shared \
		--enable-static \
		--without-x \
	)
	touch $@

$(JPEG_DIR)/.libs/libjpeg.a: $(JPEG_DIR)/.configured
	$(MAKE) -C $(JPEG_DIR) all
	touch -c $@

$(STAGING_DIR)/lib/libjpeg.a: $(JPEG_DIR)/.libs/libjpeg.a
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(JPEG_DIR) install-headers install-lib
	rm $(STAGING_DIR)/lib/libjpeg.la
	touch -c $@

$(TARGET_DIR)/usr/lib/libjpeg.so: $(STAGING_DIR)/lib/libjpeg.a
	cp -dpf $(STAGING_DIR)/lib/libjpeg.so* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libjpeg.so*
	touch -c $@

jpeg: uclibc $(TARGET_DIR)/usr/lib/libjpeg.so

jpeg-clean:
	-$(MAKE) -C $(JPEG_DIR) clean

jpeg-dirclean:
	rm -rf $(JPEG_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_JPEG)),y)
TARGETS+=jpeg
endif
