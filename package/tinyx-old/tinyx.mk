#############################################################
#
# tinyx - a small footprint X-server for the TuxScreen
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
#


ifneq ($(strip $(BR2_PACKAGE_XORG)),y)
ifeq ($(strip $(BR2_PACKAGE_TINYX_OLD)),y)

#############################################################
# You may want to change these.
#############################################################

TINYX_APPS:=xlsfonts/xlsfonts xmodmap/xmodmap
#xset/xset xdpyinfo/xdpyinfo xsetroot/xsetroot \
#	xrdb/xrdb xrandr/xrandr \
#	xhost/xhost xauth/xauth oclock/oclock xeyes/xeyes
#

TINYX_LIBS:=ICE X11 Xext Xpm
# Xaw SM Xt Xmu

#############################################################
# Stuff below this line shouldn't need changes.
# if you do change, look in rxvt & matchbox for the impact!
#############################################################
#
# Where resources are found.
#

TINYX_DIR:=$(BUILD_DIR)/xc-011010
TINYX_LDIR:=$(TINYX_DIR)/lib
TINYX_PROGS:=$(TINYX_DIR)/programs
TINYX_SOURCE:=xc-011010.tar.bz2
TINYX_SITE:= http://intimate.handhelds.org/jacques/
TINYX_CF:=$(TINYX_DIR)/config/cf
#
# Some things that you may want to change.
TINYX_XFBDEV:=$(TINYX_DIR)/programs/Xserver/Xfbdev
TINYX_CAT:=$(BZCAT)
TINYX_BINX:=$(TARGET_DIR)/usr/X11R6/bin/
TINYX_LIBX:=$(TARGET_DIR)/usr/lib/

#
# These rules fetch various tinyx source files.
#
$(DL_DIR)/$(TINYX_SOURCE):
	$(WGET) -P $(DL_DIR) $(TINYX_SITE)/$(TINYX_SOURCE)

#
# rule to make sure that we have the source, and it is configured.
#
$(TINYX_DIR)/.configure: $(DL_DIR)/$(TINYX_SOURCE)
	$(TINYX_CAT) $(DL_DIR)/$(TINYX_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(TINYX_DIR) package/tinyx/ tinyx\*.patch
	$(SED) 's:REPLACE_STAGING_DIR:$(STAGING_DIR):g' $(TINYX_CF)/cross.def
	$(SED) 's:REPLACE_ARCH:$(ARCH):g' $(TINYX_CF)/cross.def
	$(SED) 's:#define CcCmd.*:#define CcCmd $(TARGET_CROSS)gcc:g' $(TINYX_CF)/cross.def
	$(SED) 's:#define RanlibCmd.*:#define RanlibCmd $(TARGET_CROSS)ranlib:g' $(TINYX_CF)/cross.def
	$(SED) 's:#define LdCmd.*:#define LdCmd $(TARGET_CROSS)ld:g' $(TINYX_CF)/cross.def
	touch $(TINYX_DIR)/.configure

#
# Now that we have the source, build it...
#
$(TINYX_XFBDEV): $(TINYX_DIR)/.configure
	rm -f $(TINYX_BINX)/Xfbdev
	#make World CROSSCOMPILEFLAGS="CROSSCOMPILEDIR=<cross compiler dir>";
	#( cd $(TINYX_DIR) ; $(MAKE) World CROSSCOMPILEFLAGS="CROSSCOMPILEDIR=$(STAGING_DIR)/bin" )
	#( cd $(TINYX_DIR) ; $(TARGET_CONFIGURE_OPTS) $(MAKE) World )
	#
	#mv $(TINYX_DIR)/Makefile $(TINYX_DIR)/Makefile.xxxx
	#echo "AS=$(TARGET_CROSS)as" > $(TINYX_DIR)/Makefile
	#echo "LD=$(TARGET_CROSS)ld" >> $(TINYX_DIR)/Makefile
	#echo "NM=$(TARGET_CROSS)nm" >> $(TINYX_DIR)/Makefile
	#echo "CC=$(TARGET_CROSS)gcc" >> $(TINYX_DIR)/Makefile
	#echo "GCC=$(TARGET_CROSS)gcc" >> $(TINYX_DIR)/Makefile
	#echo "CXX=$(TARGET_CROSS)g++" >> $(TINYX_DIR)/Makefile
	#echo "RANLIB=$(TARGET_CROSS)ranlib" >> $(TINYX_DIR)/Makefile
	#echo "OBJCOPY=$(TARGET_CROSS)objcopy" >> $(TINYX_DIR)/Makefile
	#cat $(TINYX_DIR)/Makefile.xxxx >> $(TINYX_DIR)/Makefile
	( cd $(TINYX_DIR) ; $(MAKE) World )

#
# Install x-includes and x-libraries in $(STAGING_DIR)/usr/X11R6/
# and add a symbolic link between /usr/bin/X11 and /usr/X11R6/bin
$(STAGING_DIR)/usr/X11R6/lib/libX11.so.6.2: $(TINYX_XFBDEV)
	mkdir -p $(STAGING_DIR)/usr/X11R6/lib
	mkdir -p $(STAGING_DIR)/usr/X11R6/include
	cp -fRL $(TINYX_DIR)/exports/include/* $(STAGING_DIR)/usr/X11R6/include/
	cp -fRL $(TINYX_DIR)/exports/lib/* $(STAGING_DIR)/usr/X11R6/lib/
	ln -s /usr/X11R6/bin $(TARGET_DIR)/usr/bin/X11

#
# Once Frame Buffer is built, we install executables.
$(TINYX_BINX)/Xfbdev: $(TINYX_XFBDEV)
	-mkdir $(TARGET_DIR)/usr/X11R6
	-mkdir $(TINYX_BINX)
	for file in $(TINYX_APPS) ; do \
		cp -f $(TINYX_DIR)/programs/$$file $(TINYX_BINX) ; \
		$(STRIP) $(TINYX_PROGS)/$$file ; \
	done
	cp $(TINYX_DIR)/programs/Xserver/Xfbdev $(TINYX_BINX)
	$(STRIP) $(TINYX_BINX)/Xfbdev
	cp -f $(TINYX_DIR)/startx $(TARGET_DIR)/bin
	chmod a+x $(TARGET_DIR)/bin/startx

#
# After we have executables installed, install the libraries.
$(TINYX_LIBX)/libX11.so.6.2: $(TINYX_XFBDEV)
	for dirs in $(TINYX_LIBS) ; do \
		file=`find $(TINYX_LDIR)/$$dirs -type f -iname "lib$$dirs.so*"` ; \
		$(STRIP) --strip-unneeded $$file ; \
		cp -f $$file $(TINYX_LIBX) ; \
		file=`find $(TINYX_LDIR)/$$dirs -type l -iname "lib$$dirs.so*"` ; \
		cp -pRf $$file $(TINYX_LIBX) ; \
	done

tinyx: zlib $(STAGING_DIR)/usr/X11R6/lib/libX11.so.6.2 \
	$(TINYX_LIBX)/libX11.so.6.2 $(TINYX_BINX)/Xfbdev

tinyx-source: $(DL_DIR)/$(TINYX_SOURCE)

tinyx-clean:
	-rm -rf $(TARGET_DIR)/usr/X11R6
	-$(MAKE) -C $(TINYX_DIR) clean

tinyx-dirclean:
	-rm -rf $(TINYX_DIR)
	-rm -rf $(TARGET_DIR)/usr/X11R6
#############################################################
#
# Toplevel Makefile options
#
#############################################################
TARGETS+=tinyx
endif
endif
