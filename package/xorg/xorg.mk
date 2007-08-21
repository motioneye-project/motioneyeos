#############################################################
#
# xorg X Window System
#
#############################################################

ifneq ($(strip $(BR2_PACKAGE_TINYX)),y)
ifeq ($(strip $(BR2_PACKAGE_XORG)),y)

XORG_APPS:=xlsfonts/xlsfonts xmodmap/xmodmap xinit/startx \
	xauth/xauth xinit/xinit xsetroot/xsetroot xset/xset \
	mkfontscale/mkfontscale mkfontdir/mkfontdir \
	setxkbmap/setxkbmap #xterm/xterm

XORG_LIBS:= Xft Xrender Xaw Xmu Xt Xcursor Xrandr Xi Xinerama Xfixes \
	SM ICE Xpm Xp Xext X11 Xmuu Xxf86misc fontenc xkbfile


#############################################################
# Stuff below this line shouldn't need changes.
# if you do change, look in rxvt & matchbox for the impact!
#############################################################
#
# Where resources are found.
#
XORG_SOURCE:=X11R6.8.2-src.tar.bz2
XORG_SITE:=http://xorg.freedesktop.org/X11R6.8.2/src-single/
XORG_CAT:=$(BZCAT)
XORG_DIR:=$(BUILD_DIR)/xc
XORG_LDIR:=$(XORG_DIR)/lib
XORG_PROGS:=$(XORG_DIR)/programs
TARGET_BINX:=/usr/X11R6/bin
TARGET_LIBX:=/usr/X11R6/lib
XORG_BINX:=$(TARGET_DIR)$(TARGET_BINX)
XORG_LIBX:=$(TARGET_DIR)$(TARGET_LIBX)
XORG_CF:=$(XORG_DIR)/config/cf/cross.def
XORG_HOST_DEF:=$(XORG_DIR)/config/cf/host.def


DEJAVU_VERSION=2.14
DEJAVU_SOURCE=dejavu-ttf-$(DEJAVU_VERSION).tar.bz2
DEJAVU_CAT:=$(BZCAT)
DEJAVU_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/dejavu
DEJAVU_DIR:=$(BUILD_DIR)/dejavu-ttf-$(DEJAVU_VERSION)

# Install Xorg xserver
XSERVER_BINARY:=Xorg
XORG_XSERVER:=$(XORG_DIR)/programs/Xserver/$(XSERVER_BINARY)
TARGET_XSERVER:=$(XORG_BINX)/$(XSERVER_BINARY)

# figure out Xorg's idea of corresponding architecture name
ifeq ($(BR2_alpha),y)
XARCH=Alpha
endif
ifeq ($(BR2_arm),y)
XARCH=Arm32
endif
ifeq ($(BR2_armeb),y)
XARCH=Arm32
endif
ifeq ($(BR2_i386),y)
XARCH=i386
endif
ifeq ($(BR2_mips),y)
XARCH=Mips
endif
ifeq ($(BR2_mipsel),y)
XARCH=Mips
endif
ifeq ($(BR2_powerpc),y)
XARCH=Ppc
endif
ifeq ($(BR2_sparc),y)
XARCH=Sparc
endif
ifeq ($(BR2_x86_64),y)
XARCH=AMD64
endif

$(DL_DIR)/$(XORG_SOURCE):
	$(WGET) -P $(DL_DIR) $(XORG_SITE)/$(XORG_SOURCE)

$(XORG_DIR)/.unpacked: $(DL_DIR)/$(XORG_SOURCE)
	$(XORG_CAT) $(DL_DIR)/$(XORG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(XORG_DIR) package/xorg/ \*.patch
	touch $(XORG_DIR)/.unpacked

$(XORG_DIR)/.configured: $(XORG_DIR)/.unpacked
	$(SED) 's:REPLACE_STAGING_DIR:$(STAGING_DIR):g' $(XORG_HOST_DEF)
	$(SED) 's:REPLACE_GCCINC_DIR:$(shell $(TARGET_CROSS)gcc -print-file-name=include):g' $(XORG_CF)
	$(SED) 's:REPLACE_STAGING_DIR:$(STAGING_DIR):g' $(XORG_CF)
	$(SED) 's:REPLACE_ARCH:$(ARCH):g' $(XORG_CF)
	$(SED) 's:#define StdIncDir.*:#define StdIncDir $(STAGING_DIR)/usr/include:g' $(XORG_CF)
	$(SED) 's:#define CcCmd.*:#define CcCmd $(TARGET_CROSS)gcc:g' $(XORG_CF)
	$(SED) 's:#define RanlibCmd.*:#define RanlibCmd $(TARGET_CROSS)ranlib:g' $(XORG_CF)
	$(SED) 's:#define LdCmd.*:#define LdCmd $(TARGET_CROSS)ld:g' $(XORG_CF)
	$(SED) 's:#.*define.*HasPam.*YES::g' $(XORG_DIR)/config/cf/linux.cf
	$(SED) 's:#.*define.*CrossCompiling.*NO:#define CrossCompiling YES:g' $(XORG_DIR)/config/cf/Imake.tmpl
	$(SED) 's:#.*undef.*CrossCompileDir.*:#define CrossCompileDir $(STAGING_DIR)/bin:g' $(XORG_DIR)/config/cf/Imake.tmpl
	$(SED) 's:REPLACE_XORG_ARCH:$(XARCH):g' $(XORG_DIR)/config/cf/cross.def
	touch $(XORG_DIR)/.configured

$(XORG_XSERVER): $(XORG_DIR)/.configured
	rm -f $(TARGET_XSERVER) $(XORG_XSERVER)
	( cd $(XORG_DIR) ; $(MAKE) \
		PKG_CONFIG=$(STAGING_DIR)/$(PKGCONFIG_TARGET_BINARY) \
		World XCURSORGEN=xcursorgen MKFONTSCALE=mkfontscale )
	touch -c $(XORG_XSERVER)

$(STAGING_DIR)$(TARGET_LIBX)/libX11.so.6.2: $(XORG_XSERVER)
	mkdir -p $(STAGING_DIR)/usr/X11R6
	ln -fs ../../include $(STAGING_DIR)/usr/X11R6/include
	ln -fs ../../lib $(STAGING_DIR)$(TARGET_LIBX)
	( cd $(XORG_DIR); $(MAKE) \
		DESTDIR=$(STAGING_DIR) install XCURSORGEN=xcursorgen MKFONTSCALE=mkfontscale )
	cp package/xorg/x11.pc package/xorg/xext.pc \
		package/xorg/xproto.pc package/xorg/kbproto.pc \
		package/xorg/xau.pc package/xorg/xdmcp.pc \
		package/xorg/xextproto.pc package/xorg/xrandr.pc \
		package/xorg/xinerama.pc $(STAGING_DIR)/lib/pkgconfig
	touch -c $(STAGING_DIR)$(TARGET_LIBX)/libX11.so.6.2

$(TARGET_XSERVER): $(XORG_XSERVER)
	mkdir -p $(XORG_BINX)
	for file in $(XORG_APPS) ; do \
		cp -f $(XORG_DIR)/programs/$$file $(XORG_BINX) ; \
		chmod a+x $(XORG_PROGS)/$$file ; \
		$(STRIP) $(XORG_PROGS)/$$file || /bin/true ; \
	done
	cp $(XORG_XSERVER) $(TARGET_XSERVER)
	(cd $(XORG_BINX); ln -snf $(XSERVER_BINARY) X)
	$(STRIP) $(TARGET_XSERVER)
	mkdir -p $(XORG_LIBX)/modules
	cp -LRf $(XORG_DIR)/exports/lib/modules/ $(XORG_LIBX)/
	( cd $(XORG_DIR)/fonts ; $(MAKE) \
		DESTDIR=$(TARGET_DIR) install XCURSORGEN=xcursorgen MKFONTSCALE=mkfontscale )
	cp -LRf $(XORG_DIR)/fonts/bdf/misc/7x14.bdf $(XORG_LIBX)/X11/fonts/misc/
	cp -LRf $(XORG_DIR)/fonts/bdf/misc/7x14-L1.bdf $(XORG_LIBX)/X11/fonts/misc/
	cp -LRf $(XORG_DIR)/fonts/bdf/misc/7x14B.bdf $(XORG_LIBX)/X11/fonts/misc/
	cp -LRf $(XORG_DIR)/fonts/bdf/misc/7x14B-L1.bdf $(XORG_LIBX)/X11/fonts/misc/
	cp -LRf $(XORG_DIR)/fonts/bdf/misc/cursor.bdf $(XORG_LIBX)/X11/fonts/misc/
	cp -f package/xorg/fonts.alias $(XORG_LIBX)/X11/fonts/misc/
	( cd $(XORG_LIBX)/X11/fonts/misc/; mkfontdir )
	rm -rf $(XORG_LIBX)/X11/fonts/100dpi
	rm -rf $(XORG_LIBX)/X11/fonts/75dpi
	rm -rf $(XORG_LIBX)/X11/fonts/cyrillic
	rm -rf $(XORG_LIBX)/X11/fonts/local
	(cd $(TARGET_DIR)/usr/bin; ln -snf $(TARGET_BINX) X11)
	cp -LRf $(STAGING_DIR)$(TARGET_LIBX)/X11/xkb $(XORG_LIBX)/X11/
	mv $(XORG_LIBX)/X11/xkb/xkbcomp $(XORG_BINX)/
	(cd $(XORG_LIBX)/X11/xkb; ln -s ../../../bin/xkbcomp)
	rm -rf $(XORG_LIBX)/X11/xkb/compiled
	(cd $(XORG_LIBX)/X11/xkb; ln -s /tmp compiled)
	cp -LRf $(STAGING_DIR)$(TARGET_LIBX)/X11/icons $(XORG_LIBX)/X11/
	-cp -LRf $(STAGING_DIR)$(TARGET_LIBX)/X11/locale $(XORG_LIBX)/X11/
	cp -LRf $(STAGING_DIR)$(TARGET_LIBX)/X11/rgb.txt $(XORG_LIBX)/X11/
	cp -LRf $(STAGING_DIR)$(TARGET_LIBX)/X11/XKeysymDB $(XORG_LIBX)/X11/
	cp -LRf $(STAGING_DIR)$(TARGET_LIBX)/X11/XErrorDB $(XORG_LIBX)/X11/
	mkdir -p $(TARGET_DIR)/etc/X11/
	$(SED) "s,^sysclientrc=.*,sysclientrc=/etc/X11/Xsession,g" $(XORG_BINX)/startx
	$(SED) "s,^sysserverrc=.*,sysserverrc=/etc/X11/Xserver,g" $(XORG_BINX)/startx
	cp -LRf package/xorg/xorg.conf $(TARGET_DIR)/etc/X11/
	cp -LRf package/xorg/Xsession $(TARGET_DIR)/etc/X11/
	cp -LRf package/xorg/Xserver $(TARGET_DIR)/etc/X11/
	touch -c $(TARGET_XSERVER)

$(DL_DIR)/$(DEJAVU_SOURCE):
	$(WGET) -P $(DL_DIR) $(DEJAVU_SITE)/$(DEJAVU_SOURCE)

$(DEJAVU_DIR)/.unpacked: $(DL_DIR)/$(DEJAVU_SOURCE)
	$(DEJAVU_CAT) $(DL_DIR)/$(DEJAVU_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(DEJAVU_DIR)/.unpacked

$(XORG_LIBX)/X11/fonts/ttf-dejavu/DejaVuSansMono.ttf: $(DEJAVU_DIR)/.unpacked
	mkdir -p $(XORG_LIBX)/X11/fonts/ttf-dejavu
	rm -f $(DEJAVU_DIR)/*Condensed*.ttf
	rm -f $(DEJAVU_DIR)/*ExtraLight*.ttf
	cp -LRf $(DEJAVU_DIR)/DejaVu*-Bold.ttf $(XORG_LIBX)/X11/fonts/ttf-dejavu/
	cp -LRf $(DEJAVU_DIR)/DejaVu*-BoldOblique.ttf $(XORG_LIBX)/X11/fonts/ttf-dejavu/
	cp -LRf $(DEJAVU_DIR)/DejaVu*-Oblique.ttf $(XORG_LIBX)/X11/fonts/ttf-dejavu/
	cp -LRf $(DEJAVU_DIR)/DejaVuSans.ttf $(XORG_LIBX)/X11/fonts/ttf-dejavu/
	cp -LRf $(DEJAVU_DIR)/DejaVuSansMono.ttf $(XORG_LIBX)/X11/fonts/ttf-dejavu/
	cp -LRf $(DEJAVU_DIR)/DejaVuSerif.ttf $(XORG_LIBX)/X11/fonts/ttf-dejavu/
	cp -LRf $(DEJAVU_DIR)/DejaVuSerif.ttf $(XORG_LIBX)/X11/fonts/ttf-dejavu/
	cp package/xorg/fonts.cache-1 $(XORG_LIBX)/X11/fonts/ttf-dejavu/
	( cd $(XORG_LIBX)/X11/fonts/ttf-dejavu/; mkfontdir )
	touch -c $(XORG_LIBX)/X11/fonts/ttf-dejavu/DejaVuSansMono.ttf

$(XORG_LIBX)/libX11.so.6.2: $(TARGET_XSERVER) $(XORG_LIBX)/X11/fonts/ttf-dejavu/DejaVuSansMono.ttf
	mkdir -p $(XORG_LIBX)
	set -e; for dirs in $(XORG_LIBS) ; do \
		file=`find $(XORG_LDIR)/$$dirs -type f -iname "*$$dirs.so*"` ; \
		$(STRIP) $(STRIP_STRIP_UNNEEDED) $$file ; \
		cp -f $$file $(XORG_LIBX) ; \
		file=`find $(XORG_LDIR)/$$dirs -type l -iname "*$$dirs.so*"` ; \
		cp -pRf $$file $(XORG_LIBX) ; \
	done
	(cd $(TARGET_DIR)/usr/lib; ln -snf $(TARGET_LIBX) X11)
	touch $(TARGET_DIR)/etc/ld.so.conf
	if [ "`grep -c '$(TARGET_LIBX)' $(TARGET_DIR)/etc/ld.so.conf`" = "0" ] ; then \
		echo "$(TARGET_LIBX)" >> $(TARGET_DIR)/etc/ld.so.conf; \
	fi;
	touch -c $(XORG_LIBX)/libX11.so.6.2

$(TARGET_DIR)/usr/bin/mcookie: package/xorg/mcookie.c
	$(TARGET_CROSS)gcc -Wall -Os -s package/xorg/mcookie.c -o $(TARGET_DIR)/usr/bin/mcookie

xorg: zlib png pkgconfig expat fontconfig libdrm $(STAGING_DIR)$(TARGET_LIBX)/libX11.so.6.2 \
	$(XORG_LIBX)/libX11.so.6.2 $(TARGET_DIR)/usr/bin/mcookie

xorg-source: $(DL_DIR)/$(XORG_SOURCE) $(DL_DIR)/$(DEJAVU_SOURCE)

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
