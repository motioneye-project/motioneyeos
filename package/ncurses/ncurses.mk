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
NCURSES_VERSION = 5.7
NCURSES_SITE = $(BR2_GNU_MIRROR)/ncurses
NCURSES_SOURCE = ncurses-$(NCURSES_VERSION).tar.gz
NCURSES_INSTALL_STAGING = YES

NCURSES_CONF_OPT = \
	--with-shared \
	--without-cxx \
	--without-cxx-binding \
	--without-ada \
	--without-progs \
	--disable-big-core \
	--without-profile \
	--disable-rpath \
	--enable-echo \
	--enable-const \
	--enable-overwrite \
	--enable-broken_linker \
	--disable-static

ifneq ($(BR2_ENABLE_DEBUG),y)
NCURSES_CONF_OPT += --without-debug
endif


define NCURSES_BUILD_CMDS
	$(MAKE1) -C $(@D) DESTDIR=$(STAGING_DIR)
endef

define NCURSES_PATCH_NCURSES_CONFIG
	$(SED) 's^prefix="^prefix="$(STAGING_DIR)^' \
		$(STAGING_DIR)/usr/bin/ncurses5-config
endef

NCURSES_POST_STAGING_INSTALL_HOOKS += NCURSES_PATCH_NCURSES_CONFIG

ifeq ($(BR2_HAVE_DEVFILES),y)
define NCURSES_INSTALL_TARGET_DEVFILES
	mkdir -p $(TARGET_DIR)/usr/include
	cp -dpf $(NCURSES_DIR)/include/curses.h $(TARGET_DIR)/usr/include/curses.h
	cp -dpf $(NCURSES_DIR)/include/ncurses_dll.h $(TARGET_DIR)/usr/include/ncurses_dll.h
	cp -dpf $(NCURSES_DIR)/include/term.h $(TARGET_DIR)/usr/include/
	cp -dpf $(NCURSES_DIR)/include/unctrl.h $(TARGET_DIR)/usr/include/
	cp -dpf $(NCURSES_DIR)/include/termcap.h $(TARGET_DIR)/usr/include/
	cp -dpf $(NCURSES_DIR)/lib/libncurses.a $(TARGET_DIR)/usr/lib/
	(cd $(TARGET_DIR)/usr/lib; \
	 ln -fs libncurses.a libcurses.a; \
	 ln -fs libncurses.a libtermcap.a; \
	)
	(cd $(TARGET_DIR)/usr/include; ln -fs curses.h ncurses.h)
	rm -f $(TARGET_DIR)/usr/lib/libncurses.so
	(cd $(TARGET_DIR)/usr/lib; ln -fs libncurses.so.$(NCURSES_VERSION) libncurses.so)
endef
endif

ifeq ($(BR2_PACKAGE_NCURSES_TARGET_PANEL),y)
define NCURSES_INSTALL_TARGET_PANEL
	cp -dpf $(NCURSES_DIR)/lib/libpanel.so* $(TARGET_DIR)/usr/lib/
endef
endif

ifeq ($(BR2_PACKAGE_NCURSES_TARGET_FORM),y)
define NCURSES_INSTALL_TARGET_FORM
	cp -dpf $(NCURSES_DIR)/lib/libform.so* $(TARGET_DIR)/usr/lib/
endef
endif

ifeq ($(BR2_PACKAGE_NCURSES_TARGET_MENU),y)
define NCURSES_INSTALL_TARGET_MENU
	cp -dpf $(NCURSES_DIR)/lib/libmenu.so* $(TARGET_DIR)/usr/lib/
endef
endif

define NCURSES_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib
	cp -dpf $(NCURSES_DIR)/lib/libncurses.so* $(TARGET_DIR)/usr/lib/
	$(NCURSES_INSTALL_TARGET_PANEL)
	$(NCURSES_INSTALL_TARGET_FORM)
	$(NCURSES_INSTALL_TARGET_MENU)
	ln -snf /usr/share/terminfo $(TARGET_DIR)/usr/lib/terminfo
	mkdir -p $(TARGET_DIR)/usr/share/terminfo/x
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/x/xterm $(TARGET_DIR)/usr/share/terminfo/x
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/x/xterm-color $(TARGET_DIR)/usr/share/terminfo/x
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/x/xterm-xfree86 $(TARGET_DIR)/usr/share/terminfo/x
	mkdir -p $(TARGET_DIR)/usr/share/terminfo/v
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/v/vt100 $(TARGET_DIR)/usr/share/terminfo/v
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/v/vt102 $(TARGET_DIR)/usr/share/terminfo/v
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/v/vt200 $(TARGET_DIR)/usr/share/terminfo/v
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/v/vt220 $(TARGET_DIR)/usr/share/terminfo/v
	mkdir -p $(TARGET_DIR)/usr/share/terminfo/a
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/a/ansi $(TARGET_DIR)/usr/share/terminfo/a
	mkdir -p $(TARGET_DIR)/usr/share/terminfo/l
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/l/linux $(TARGET_DIR)/usr/share/terminfo/l
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libncurses.so*
	$(NCURSES_INSTALL_TARGET_DEVFILES)
endef # NCURSES_INSTALL_TARGET_CMDS

$(eval $(call AUTOTARGETS,package,ncurses))
