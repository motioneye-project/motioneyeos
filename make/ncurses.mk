#############################################################
#
# ncurses
# this installs only a few vital termcap entries
#
#############################################################
# Copyright (C) 2002 by Ken Restivo <ken@246gt.com>
# $Id: ncurses.mk,v 1.12 2003/01/08 02:37:03 andersen Exp $
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
NCURSES_SITE:=ftp://ftp.gnu.org/pub/gnu/ncurses
NCURSES_DIR:=$(BUILD_DIR)/ncurses-5.2
NCURSES_SOURCE:=ncurses-5.2.tar.gz

$(DL_DIR)/$(NCURSES_SOURCE):
	$(WGET) -P $(DL_DIR) $(NCURSES_SITE)/$(NCURSES_SOURCE)

$(NCURSES_DIR)/.dist: $(DL_DIR)/$(NCURSES_SOURCE)
	gunzip -c $(DL_DIR)/$(NCURSES_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	#use the local tic and not whatever the build system was going to find.
	perl -i -p -e 's~\$$srcdir/shlib tic\$$suffix~/usr/bin/tic~' \
		$(NCURSES_DIR)/misc/run_tic.in
	touch  $(NCURSES_DIR)/.dist

$(NCURSES_DIR)/.configured: $(NCURSES_DIR)/.dist
	(cd $(NCURSES_DIR); rm -rf config.cache; \
	    BUILD_CC=$(HOSTCC) HOSTCC=$(HOSTCC) CC=$(TARGET_CC1) \
	    ./configure --target=$(GNU_TARGET_NAME) --prefix=$(STAGING_DIR) \
	    --with-shared --without-cxx --without-cxx-binding --without-ada \
	    --without-progs --exec_prefix=$(STAGING_DIR)/usr/bin \
	    --libdir=$(STAGING_DIR)/lib --includedir=$(STAGING_DIR)/include \
	    --disable-nls);
	touch  $(NCURSES_DIR)/.configured

$(NCURSES_DIR)/lib/libncurses.so: $(NCURSES_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC1) HOSTCC=$(HOSTCC) \
		DESTDIR=$(STAGING_DIR) -C $(NCURSES_DIR)

$(STAGING_DIR)/lib/libncurses.so: $(NCURSES_DIR)/lib/libncurses.so
	cp -dpf $(NCURSES_DIR)/lib/libncurses.so* $(STAGING_DIR)/lib/
	cp -dpf $(NCURSES_DIR)/include/curses.h $(STAGING_DIR)/include/
	cp -dpf $(NCURSES_DIR)/include/eti.h $(STAGING_DIR)/include/
	cp -dpf $(NCURSES_DIR)/include/form.h $(STAGING_DIR)/include/
	cp -dpf $(NCURSES_DIR)/include/menu.h $(STAGING_DIR)/include/
	cp -dpf $(NCURSES_DIR)/include/panel.h $(STAGING_DIR)/include/
	cp -dpf $(NCURSES_DIR)/include/term.h $(STAGING_DIR)/include/
	cp -dpf $(NCURSES_DIR)/include/termcap.h $(STAGING_DIR)/include/
	cp -dpf $(NCURSES_DIR)/include/unctrl.h $(STAGING_DIR)/include/
	(cd $(STAGING_DIR)/include; ln -fs curses.h ncurses.h)

$(TARGET_DIR)/lib/libncurses.so: $(STAGING_DIR)/lib/libncurses.so
	cp -dpf $(STAGING_DIR)/lib/libncurses.so* $(TARGET_DIR)/lib/
	-cp -dpf $(STAGING_DIR)/usr/lib/terminfo $(TARGET_DIR)/usr/lib/
	for i in x/xterm x/xterm-color x/xterm-xfree86 v/vt100 v/vt200 a/ansi l/linux; do \
		cd $(STAGING_DIR)/usr/share/; \
		tar -cf - terminfo/$${i} | \
			tar -C $(TARGET_DIR)/usr/share/ -xf - ; \
	done

$(TARGET_DIR)/usr/include/curses.h: $(TARGET_DIR)/lib/libncurses.so
	cp -dpf $(NCURSES_DIR)/include/curses.h $(TARGET_DIR)/include/
	cp -dpf $(NCURSES_DIR)/include/eti.h $(TARGET_DIR)/include/
	cp -dpf $(NCURSES_DIR)/include/form.h $(TARGET_DIR)/include/
	cp -dpf $(NCURSES_DIR)/include/menu.h $(TARGET_DIR)/include/
	cp -dpf $(NCURSES_DIR)/include/panel.h $(TARGET_DIR)/include/
	cp -dpf $(NCURSES_DIR)/include/term.h $(TARGET_DIR)/include/
	cp -dpf $(NCURSES_DIR)/include/termcap.h $(TARGET_DIR)/include/
	cp -dpf $(NCURSES_DIR)/include/unctrl.h $(TARGET_DIR)/include/
	(cd $(TARGET_DIR)/include; ln -fs curses.h ncurses.h)

ncurses-headers: $(TARGET_DIR)/usr/include/curses.h

ncurses-clean: 
	rm -f $(STAGING_DIR)/lib/libncurses.so* $(TARGET_DIR)/lib/libncurses.so*
	rm -f $(STAGING_DIR)/usr/share/tabset $(TARGET_DIR)/usr/share/tabset
	rm -rf $(STAGING_DIR)/usr/share/terminfo $(TARGET_DIR)/usr/share/terminfo
	-$(MAKE) -C $(NCURSES_DIR) clean

ncurses-dirclean: 
	rm -rf $(NCURSES_DIR)

ncurses: $(TARGET_DIR)/lib/libncurses.so 

