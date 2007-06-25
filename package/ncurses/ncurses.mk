#############################################################
#
# ncurses
# this installs only a few vital termcap entries
#
#############################################################
# Copyright (C) 2002 by Ken Restivo <ken@246gt.com>
# $Id: ncurses.mk,v 1.7 2005/01/03 04:38:13 andersen Exp $
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

# TARGETS
NCURSES_VER:=5.6
NCURSES_SITE:=http://ftp.gnu.org/pub/gnu/ncurses
NCURSES_DIR:=$(BUILD_DIR)/ncurses-$(NCURSES_VER)
NCURSES_SOURCE:=ncurses-$(NCURSES_VER).tar.gz
NCURSES_CAT:=$(ZCAT)

ifneq ($(strip $(BR2_PACKAGE_NCURSES_TARGET_HEADERS)),y)
NCURSES_WANT_STATIC=--disable-static
endif

$(DL_DIR)/$(NCURSES_SOURCE):
	$(WGET) -P $(DL_DIR) $(NCURSES_SITE)/$(NCURSES_SOURCE)

$(NCURSES_DIR)/.patched: $(DL_DIR)/$(NCURSES_SOURCE)
	$(NCURSES_CAT) $(DL_DIR)/$(NCURSES_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	#use the local tic and not whatever the build system was going to find.
	$(SED) 's~\$$srcdir/shlib tic\$$suffix~/usr/bin/tic~' \
		$(NCURSES_DIR)/misc/run_tic.in
	toolchain/patch-kernel.sh $(NCURSES_DIR) package/ncurses/ ncurses\*.patch
	$(CONFIG_UPDATE) $(NCURSES_DIR)
	touch $@

$(NCURSES_DIR)/.configured: $(NCURSES_DIR)/.patched
	(cd $(NCURSES_DIR); rm -rf config.cache; \
		BUILD_CC="$(HOSTCC)" \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(REAL_GNU_TARGET_NAME) \
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
		--mandir=/usr/man \
		--infodir=/usr/info \
		--with-terminfo-dirs=/usr/share/terminfo \
		--with-default-terminfo-dir=/usr/share/terminfo \
		--with-shared --without-cxx --without-cxx-binding \
		--without-ada --without-progs --disable-big-core \
		$(DISABLE_NLS) $(DISABLE_LARGEFILE) \
		--without-profile --without-debug --disable-rpath \
		--enable-echo --enable-const --enable-overwrite \
		--enable-broken_linker \
		$(NCURSES_WANT_STATIC) \
	);
	touch $@

$(NCURSES_DIR)/lib/libncurses.so.$(NCURSES_VER): $(NCURSES_DIR)/.configured
	$(MAKE1) DESTDIR=$(STAGING_DIR) -C $(NCURSES_DIR) \
		libs panel menu form headers

$(STAGING_DIR)/lib/libncurses.so.$(NCURSES_VER): $(NCURSES_DIR)/lib/libncurses.so.$(NCURSES_VER)
	$(MAKE1) \
	    prefix=$(STAGING_DIR)/usr/ \
	    exec_prefix=$(STAGING_DIR) \
	    bindir=$(STAGING_DIR)/bin \
	    sbindir=$(STAGING_DIR)/sbin \
	    libexecdir=$(STAGING_DIR)/usr/lib \
	    datadir=$(STAGING_DIR)/usr/share \
	    sysconfdir=$(STAGING_DIR)/etc \
	    localstatedir=$(STAGING_DIR)/var \
	    libdir=$(STAGING_DIR)/lib \
	    infodir=$(STAGING_DIR)/usr/info \
	    mandir=$(STAGING_DIR)/usr/man \
	    includedir=$(STAGING_DIR)/usr/include \
	    gxx_include_dir=$(STAGING_DIR)/usr/include/c++ \
	    ticdir=$(STAGING_DIR)/usr/share/terminfo \
	    -C $(NCURSES_DIR) install
	chmod a-x $(NCURSES_DIR)/lib/libncurses.so*
	touch -c $@

$(TARGET_DIR)/lib/libncurses.so.$(NCURSES_VER): $(STAGING_DIR)/lib/libncurses.so.$(NCURSES_VER)
	cp -dpf $(NCURSES_DIR)/lib/libncurses.so* $(TARGET_DIR)/lib/
	-cp -dpf $(STAGING_DIR)/usr/lib/terminfo $(TARGET_DIR)/usr/lib/
	mkdir -p $(TARGET_DIR)/usr/share/terminfo/x
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/x/xterm $(TARGET_DIR)/usr/share/terminfo/x
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/x/xterm-color $(TARGET_DIR)/usr/share/terminfo/x
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/x/xterm-xfree86 $(TARGET_DIR)/usr/share/terminfo/x
	mkdir -p $(TARGET_DIR)/usr/share/terminfo/v
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/v/vt100 $(TARGET_DIR)/usr/share/terminfo/v
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/v/vt200 $(TARGET_DIR)/usr/share/terminfo/v
	mkdir -p $(TARGET_DIR)/usr/share/terminfo/a
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/a/ansi $(TARGET_DIR)/usr/share/terminfo/a
	mkdir -p $(TARGET_DIR)/usr/share/terminfo/l
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/l/linux $(TARGET_DIR)/usr/share/terminfo/l
	-$(STRIP) --strip-unneeded $@
	touch -c $@

$(TARGET_DIR)/usr/lib/libncurses.a: $(STAGING_DIR)/lib/libncurses.a
	-mkdir -p $(TARGET_DIR)/usr/include
	cp -dpf $(NCURSES_DIR)/include/curses.h $(TARGET_DIR)/usr/include/ncurses.h
	cp -dpf $(NCURSES_DIR)/include/ncurses_dll.h $(TARGET_DIR)/usr/include/ncurses_dll.h
	cp -dpf $(NCURSES_DIR)/include/term.h $(TARGET_DIR)/usr/include/
	cp -dpf $(NCURSES_DIR)/include/unctrl.h $(TARGET_DIR)/usr/include/
	cp -dpf $(NCURSES_DIR)/include/termcap.h $(TARGET_DIR)/usr/include/
	cp -dpf $(NCURSES_DIR)/lib/libncurses.a $(TARGET_DIR)/usr/lib/
	rm -f $(TARGET_DIR)/usr/lib/terminfo
	(cd $(TARGET_DIR)/usr/lib; ln -fs ../share/terminfo ; \
	 ln -fs libncurses.a libcurses.a ; \
	 ln -fs libncurses.a libtermcap.a ; \
	)
	(cd $(TARGET_DIR)/usr/include; ln -fs ncurses.h curses.h)
	rm -f $(TARGET_DIR)/lib/libncurses.so
	(cd $(TARGET_DIR)/usr/lib; ln -fs ../../lib/libncurses.so.$(NCURSES_VER) libncurses.so)
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libncurses.so.$(NCURSES_VER)
	touch -c $@

ncurses: $(TARGET_DIR)/lib/libncurses.so.$(NCURSES_VER)

ncurses-headers: $(TARGET_DIR)/usr/lib/libncurses.a

ncurses-source: $(DL_DIR)/$(NCURSES_SOURCE)

ncurses-clean:
	rm -f $(STAGING_DIR)/lib/libncurses.so* $(TARGET_DIR)/lib/libncurses.so*
	rm -f $(STAGING_DIR)/usr/lib/libncurses.so* $(TARGET_DIR)/usr/lib/libncurses.so*
	rm -rf $(STAGING_DIR)/usr/share/tabset $(TARGET_DIR)/usr/share/tabset
	rm -rf $(STAGING_DIR)/usr/share/terminfo $(TARGET_DIR)/usr/share/terminfo
	-$(MAKE) -C $(NCURSES_DIR) clean

ncurses-dirclean:
	rm -rf $(NCURSES_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_NCURSES)),y)
TARGETS+=ncurses
endif
ifeq ($(strip $(BR2_PACKAGE_NCURSES_TARGET_HEADERS)),y)
TARGETS+=ncurses-headers
endif
