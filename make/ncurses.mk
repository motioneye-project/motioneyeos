#############################################################
#
# ncurses
# this installs only a few vital termcap entries
#
#############################################################
# Copyright (C) 2002 by Ken Restivo <ken@246gt.com>
# $Id: ncurses.mk,v 1.1 2002/05/23 19:21:23 andersen Exp $
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
	@echo "==============downloading ncurses...."
	wget -P $(DL_DIR) --passive-ftp $(NCURSES_SITE)/$(NCURSES_SOURCE)

$(NCURSES_DIR)/.dist: $(DL_DIR)/$(NCURSES_SOURCE)
	@echo "==============untarring and patching ncurses...."
	gunzip -c $(DL_DIR)/$(NCURSES_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	#use the local tic and not whatever the build system was going to find.
	perl -i -p -e 's~\$$srcdir/shlib tic\$$suffix~/usr/bin/tic~' \
		$(NCURSES_DIR)/misc/run_tic.in
	touch  $(NCURSES_DIR)/.dist

$(NCURSES_DIR)/Makefile: $(NCURSES_DIR)/.dist
	@echo "==============configuring ncurses...."
	(cd ${NCURSES_DIR}; \
	export PATH="${TARGET_PATH}"; \
	./configure --with-shared --prefix=/usr --target=arm-linux  \
	--enable-warnings --without-cxx --without-cxx-binding \
	--exec_prefix=${STAGING_DIR}/usr/bin \
	--libdir=${STAGING_DIR}/lib --includedir=${STAGING_DIR}/include) 


$(NCURSES_DIR)/lib/libncurses.so: $(NCURSES_DIR)/Makefile
	@echo "==============making ncurses...."
	make -C $(NCURSES_DIR)    DESTDIR=$(STAGING_DIR) \
	CC="${TARGET_CC}" LD="${TARGET_LD}" AS="${TARGET_AS}" \
	BUILD_CC=/usr/bin/gcc

$(STAGING_DIR)/lib/libncurses.so: $(NCURSES_DIR)/lib/libncurses.so
	@echo "==============installing ncurses into staging...."
	make -C $(NCURSES_DIR) install  DESTDIR=$(STAGING_DIR)

$(TARGET_DIR)/lib/libncurses.so: $(STAGING_DIR)/lib/libncurses.so
	@echo "==============installing ncurses into root dir...."
	cp -a $(STAGING_DIR)/lib/libncurses.so* $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/usr/share/tabset $(TARGET_DIR)/usr/share/
	cp -a $(STAGING_DIR)/usr/lib/terminfo $(TARGET_DIR)/usr/lib/
	for i in x/xterm x/xterm-color x/xterm-xfree86 v/vt100 v/vt200 a/ansi l/linux; do \
		cd $(STAGING_DIR)/usr/share/; \
		tar -cf - terminfo/$${i} | \
			tar -C $(TARGET_DIR)/usr/share/ -xf - ; \
	done

ncurses-clean: 
	@echo "==============cleaning ncurses...."
	rm -f $(STAGING_DIR)/lib/libncurses.so* $(TARGET_DIR)/lib/libncurses.so*
	rm -f $(STAGING_DIR)/usr/share/tabset $(TARGET_DIR)/usr/share/tabset
	rm -f $(STAGING_DIR)/usr/share/terminfo $(TARGET_DIR)/usr/share/terminfo
	make -C $(NCURSES_DIR) clean

ncurses-dirclean: 
	@echo "==============cleaning ncurses...."
	rm -rf $(NCURSES_DIR)

ncurses: $(TARGET_DIR)/lib/libncurses.so 

#EOF

