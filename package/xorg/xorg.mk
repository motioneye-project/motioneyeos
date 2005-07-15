#############################################################
#
# xorg X Window System
#
#############################################################

ifneq ($(strip $(BR2_PACKAGE_TINYX)),y)
ifeq ($(strip $(BR2_PACKAGE_XORG)),y)

XORG_APPS:=xlsfonts/xlsfonts xmodmap/xmodmap
#xset/xset xdpyinfo/xdpyinfo xsetroot/xsetroot \
#	xrdb/xrdb xrandr/xrandr \
#	xhost/xhost xauth/xauth oclock/oclock xeyes/xeyes
#

XORG_LIBS:=ICE X11 Xext Xpm Xmuu
# Xaw SM Xt Xmu

#############################################################
# Stuff below this line shouldn't need changes.
# if you do change, look in rxvt & matchbox for the impact!
#############################################################
#
# Where resources are found.
#
XORG_SOURCE:=X11R6.8.2-src.tar.bz2
XORG_SITE:=http://xorg.freedesktop.org/X11R6.8.2/src-single/
XORG_CAT:=bzcat
XORG_DIR:=$(BUILD_DIR)/xc
XORG_LDIR:=$(XORG_DIR)/lib
XORG_PROGS:=$(XORG_DIR)/programs
TARGET_BINX:=/usr/X11R6/bin/
TARGET_LIBX:=/usr/X11R6/lib/
XORG_BINX:=$(TARGET_DIR)$(TARGET_BINX)
XORG_LIBX:=$(TARGET_DIR)$(TARGET_LIBX)
XORG_CF:=$(XORG_DIR)/config/cf/cross.def

# Install Xorg xserver
XSERVER:=Xorg
XORG_XSERVER:=$(XORG_DIR)/programs/Xserver/$(XSERVER)
TARGET_XSERVER:=$(XORG_BINX)/$(XSERVER)

$(DL_DIR)/$(XORG_SOURCE):
	$(WGET) -P $(DL_DIR) $(XORG_SITE)/$(XORG_SOURCE)

$(XORG_DIR)/.configure: $(DL_DIR)/$(XORG_SOURCE)
	$(XORG_CAT) $(DL_DIR)/$(XORG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(XORG_DIR) package/xorg/ xorg\*.patch
	$(SED) 's:REPLACE_GCCINC_DIR:$(shell $(TARGET_CROSS)gcc -print-file-name=include):g' $(XORG_CF)
	$(SED) 's:REPLACE_STAGING_DIR:$(STAGING_DIR):g' $(XORG_CF)
	$(SED) 's:REPLACE_ARCH:$(ARCH):g' $(XORG_CF)
	$(SED) 's:#define CcCmd.*:#define CcCmd $(TARGET_CROSS)gcc:g' $(XORG_CF)
	$(SED) 's:#define RanlibCmd.*:#define RanlibCmd $(TARGET_CROSS)ranlib:g' $(XORG_CF)
	$(SED) 's:#define LdCmd.*:#define LdCmd $(TARGET_CROSS)ld:g' $(XORG_CF)
	$(SED) 's:#.*define.*HasPam.*YES::g' $(XORG_DIR)/config/cf/linux.cf
	$(SED) 's:#.*define.*CrossCompiling.*NO:#define CrossCompiling YES:g' $(XORG_DIR)/config/cf/Imake.tmpl
	$(SED) 's:#.*undef.*CrossCompileDir.*:#define CrossCompileDir$(STAGING_DIR)/bin:g' $(XORG_DIR)/config/cf/Imake.tmpl
	touch $(XORG_DIR)/.configure

$(XORG_XSERVER): $(XORG_DIR)/.configure
	rm -f $(TARGET_XSERVER) $(XORG_XSERVER)
	( cd $(XORG_DIR) ; $(MAKE) World XCURSORGEN=xcursorgen MKFONTSCALE=mkfontscale )

$(TARGET_XSERVER): $(XORG_XSERVER)
	-mkdir -p $(XORG_BINX)
	for file in $(XORG_APPS) ; do \
		cp -f $(XORG_DIR)/programs/$$file $(XORG_BINX) ; \
		$(STRIP) $(XORG_PROGS)/$$file ; \
	done
	cp $(XORG_XSERVER) $(TARGET_XSERVER)
	(cd $(XORG_BINX); ln -snf $(XSERVER) X)
	$(STRIP) $(TARGET_XSERVER)
	cp -f $(XORG_DIR)/programs/xinit/startx $(XORG_BINX)
	cp -f $(XORG_DIR)/programs/xauth/xauth $(XORG_BINX)
	cp -f $(XORG_DIR)/programs/xinit/xinit $(XORG_BINX)
	chmod a+x $(XORG_BINX)/startx $(XORG_BINX)/xauth $(XORG_BINX)/xinit
	mkdir -p $(XORG_LIBX)/modules
	cp -LRf $(XORG_DIR)/exports/lib/modules/ $(XORG_LIBX)/
	( cd $(XORG_DIR)/fonts ; $(MAKE) DESTDIR=$(TARGET_DIR) install XCURSORGEN=xcursorgen MKFONTSCALE=mkfontscale )
	#( cd $(XORG_DIR) ; $(MAKE) DESTDIR=$(TARGET_DIR) install XCURSORGEN=xcursorgen MKFONTSCALE=mkfontscale )
	(cd $(TARGET_DIR)/usr/bin; ln -snf $(TARGET_BINX) X11)

$(XORG_LIBX)/libX11.so.6.2: $(XORG_XSERVER)
	-mkdir -p $(XORG_LIBX)
	for dirs in $(XORG_LIBS) ; do \
		file=`find $(XORG_LDIR)/$$dirs -type f -iname "lib$$dirs.so*"` ; \
		$(STRIP) --strip-unneeded $$file ; \
		cp -f $$file $(XORG_LIBX) ; \
		file=`find $(XORG_LDIR)/$$dirs -type l -iname "lib$$dirs.so*"` ; \
		cp -pRf $$file $(XORG_LIBX) ; \
	done
	(cd $(TARGET_DIR)/usr/lib; ln -snf $(TARGET_LIBX) X11)
	echo "$(TARGET_LIBX)" >> $(TARGET_DIR)/etc/ld.so.conf


xorg: zlib $(XORG_LIBX)/libX11.so.6.2 $(TARGET_XSERVER)

xorg-source: $(DL_DIR)/$(XORG_SOURCE)

xorg-clean:
	-rm -rf $(TARGET_DIR)/usr/X11R6
	-$(MAKE) -C $(XORG_DIR) clean

xorg-dirclean:
	-rm -rf $(XORG_DIR)
	-rm -rf $(TARGET_DIR)/usr/X11R6

#############################################################
#
# Toplevel Makefile options
#
#############################################################
TARGETS+=xorg
endif
endif
