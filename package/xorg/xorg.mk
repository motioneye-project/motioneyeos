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
	#xterm/xterm

XORG_LIBS:= Xft fontconfig expat Xrender Xaw Xmu Xt \
	SM ICE Xpm Xp Xext X11 Xmuu Xxf86misc


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
TARGET_BINX:=/usr/X11R6/bin
TARGET_LIBX:=/usr/X11R6/lib
XORG_BINX:=$(TARGET_DIR)$(TARGET_BINX)
XORG_LIBX:=$(TARGET_DIR)$(TARGET_LIBX)
XORG_CF:=$(XORG_DIR)/config/cf/cross.def
XORG_HOST_DEF:=$(XORG_DIR)/config/cf/host.def

# Install Xorg xserver
XSERVER:=Xorg
XORG_XSERVER:=$(XORG_DIR)/programs/Xserver/$(XSERVER)
TARGET_XSERVER:=$(XORG_BINX)/$(XSERVER)

# Check if we should use FreeType2.
ifeq ($(BR2_PACKAGE_FREETYPE),y)
HAS_FREETYPE2=YES
else
HAS_FREETYPE2=NO
endif

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

$(XORG_DIR)/.configured: $(DL_DIR)/$(XORG_SOURCE)
	$(XORG_CAT) $(DL_DIR)/$(XORG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(XORG_DIR) package/xorg/ \*.patch
	$(SED) 's:REPLACE_STAGING_DIR:$(STAGING_DIR):g' $(XORG_HOST_DEF)
	$(SED) 's:REPLACE_HAS_FREETYPE2:$(HAS_FREETYPE2):g' $(XORG_HOST_DEF)
	$(SED) 's:REPLACE_GCCINC_DIR:$(shell $(TARGET_CROSS)gcc -print-file-name=include):g' $(XORG_CF)
	$(SED) 's:REPLACE_STAGING_DIR:$(STAGING_DIR):g' $(XORG_CF)
	$(SED) 's:REPLACE_ARCH:$(ARCH):g' $(XORG_CF)
	$(SED) 's:#define CcCmd.*:#define CcCmd $(TARGET_CROSS)gcc:g' $(XORG_CF)
	$(SED) 's:#define RanlibCmd.*:#define RanlibCmd $(TARGET_CROSS)ranlib:g' $(XORG_CF)
	$(SED) 's:#define LdCmd.*:#define LdCmd $(TARGET_CROSS)ld:g' $(XORG_CF)
	$(SED) 's:#.*define.*HasPam.*YES::g' $(XORG_DIR)/config/cf/linux.cf
	$(SED) 's:#.*define.*CrossCompiling.*NO:#define CrossCompiling YES:g' $(XORG_DIR)/config/cf/Imake.tmpl
	$(SED) 's:#.*undef.*CrossCompileDir.*:#define CrossCompileDir$(STAGING_DIR)/bin:g' $(XORG_DIR)/config/cf/Imake.tmpl
	$(SED) 's:REPLACE_XORG_ARCH:$(XARCH):g' $(XORG_DIR)/config/cf/cross.def
	touch $(XORG_DIR)/.configured

$(XORG_XSERVER): $(XORG_DIR)/.configured
	rm -f $(TARGET_XSERVER) $(XORG_XSERVER)
	( cd $(XORG_DIR) ; $(MAKE) \
		PKG_CONFIG=$(STAGING_DIR)/$(PKGCONFIG_TARGET_BINARY) \
		World XCURSORGEN=xcursorgen MKFONTSCALE=mkfontscale )
	touch -c $(XORG_XSERVER)

$(STAGING_DIR)$(TARGET_LIBX)/libX11.so.6.2: $(XORG_XSERVER)
	-mkdir -p $(STAGING_DIR)$(TARGET_LIBX)
	( cd $(XORG_DIR); $(MAKE) \
		DESTDIR=$(STAGING_DIR) install XCURSORGEN=xcursorgen MKFONTSCALE=mkfontscale )
	touch -c $(STAGING_DIR)$(TARGET_LIBX)/libX11.so.6.2

$(TARGET_XSERVER): $(XORG_XSERVER)
	-mkdir -p $(XORG_BINX)
	for file in $(XORG_APPS) ; do \
		cp -f $(XORG_DIR)/programs/$$file $(XORG_BINX) ; \
		chmod a+x $(XORG_PROGS)/$$file ; \
		$(STRIP) $(XORG_PROGS)/$$file || /bin/true ; \
	done
	cp $(XORG_XSERVER) $(TARGET_XSERVER)
	(cd $(XORG_BINX); ln -snf $(XSERVER) X)
	$(STRIP) $(TARGET_XSERVER)
	mkdir -p $(XORG_LIBX)/modules
	cp -LRf $(XORG_DIR)/exports/lib/modules/ $(XORG_LIBX)/
	( cd $(XORG_DIR)/fonts ; $(MAKE) \
		DESTDIR=$(TARGET_DIR) install XCURSORGEN=xcursorgen MKFONTSCALE=mkfontscale )
	cp -LRf $(XORG_DIR)/fonts/bdf/misc/*.bdf $(XORG_LIBX)/X11/fonts/misc/
	( cd $(XORG_LIBX)/X11/fonts/misc/; mkfontdir )
	(cd $(TARGET_DIR)/usr/bin; ln -snf $(TARGET_BINX) X11)
	mkdir -p $(TARGET_DIR)/etc/X11/
	cp package/xorg/xorg.conf $(TARGET_DIR)/etc/X11/
	cp -a $(STAGING_DIR)$(TARGET_LIBX)/X11/rgb* $(XORG_LIBX)/X11/
	touch -c $(TARGET_XSERVER)

$(XORG_LIBX)/libX11.so.6.2: $(TARGET_XSERVER)
	-mkdir -p $(XORG_LIBX)
	set -e; for dirs in $(XORG_LIBS) ; do \
		file=`find $(XORG_LDIR)/$$dirs -type f -iname "*$$dirs.so*"` ; \
		$(STRIP) --strip-unneeded $$file ; \
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


xorg: zlib png $(STAGING_DIR)$(TARGET_LIBX)/libX11.so.6.2 $(XORG_LIBX)/libX11.so.6.2

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
