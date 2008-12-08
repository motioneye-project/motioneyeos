#############################################################
#
# rxvt
#
#############################################################
# Copyright (C) 2002 by Tom Walsh <Tom@OpenHardware.net>
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

RXVT_VERSION:=2.7.5
RXVT_SOURCE:=rxvt-$(RXVT_VERSION).tar.gz
RXVT_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/rxvt
RXVT_CAT:=$(ZCAT)
RXVT_DIR:=$(BUILD_DIR)/rxvt-$(RXVT_VERSION)
RXVT_BINARY:=$(RXVT_DIR)/src/rxvt

$(DL_DIR)/$(RXVT_SOURCE):
	 $(WGET) -P $(DL_DIR) $(RXVT_SITE)/$(RXVT_SOURCE)

rxvt-source: $(DL_DIR)/$(RXVT_SOURCE)

$(RXVT_DIR)/.unpacked: $(DL_DIR)/$(RXVT_SOURCE)
	$(RXVT_CAT) $(DL_DIR)/$(RXVT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(RXVT_DIR) package/rxvt/ \*.patch
	$(CONFIG_UPDATE) $(RXVT_DIR)/autoconf
	touch $@

$(RXVT_DIR)/.configured: $(RXVT_DIR)/.unpacked
	(cd $(RXVT_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		rxvt_cv_ptys=GLIBC \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=$(X11_PREFIX) \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--x-includes=$(STAGING_DIR)$(X11_PREFIX)/include \
		--x-libraries=$(STAGING_DIR)$(X11_PREFIX)/lib \
		--disable-resources \
		--disable-memset \
	)
	touch $@

$(RXVT_BINARY): $(RXVT_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(RXVT_DIR)
	$(STRIPCMD) $(STRIP_DISCARD_ALL) $(RXVT_BINARY)

$(TARGET_DIR)$(X11_PREFIX)/bin/rxvt: $(RXVT_BINARY)
	$(INSTALL) -m 0755 -D $^ $@
	(cd $(@D); ln -fs rxvt xterm)

rxvt: $(XSERVER) $(TARGET_DIR)$(X11_PREFIX)/bin/rxvt

rxvt-clean:
	rm -f $(TARGET_DIR)$(X11_PREFIX)/bin/rxvt
	-$(MAKE) -C $(RXVT_DIR) clean

rxvt-dirclean:
	rm -rf $(RXVT_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_RXVT),y)
TARGETS+=rxvt
endif
