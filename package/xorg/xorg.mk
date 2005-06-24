#############################################################
#
# xorg X Window System
#
#############################################################

ifneq ($(strip $(BR2_PACKAGE_TINYX)),y)

XORG_APPS:=xlsfonts/xlsfonts xmodmap/xmodmap
#xset/xset xdpyinfo/xdpyinfo xsetroot/xsetroot \
#	xrdb/xrdb xrandr/xrandr \
#	xhost/xhost xauth/xauth oclock/oclock xeyes/xeyes
#

XORG_LIBS:=ICE X11 Xext Xpm
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
XORG_BINX:=$(TARGET_DIR)/usr/X11R6/bin/
XORG_LIBX:=$(TARGET_DIR)/usr/lib/
XORG_CF:=$(XORG_DIR)/config/cf/cross.def

# Install Xfbdev for use with the kernel frame buffer
XORG_XSERVER:=$(XORG_DIR)/programs/Xserver/Xfbdev

$(DL_DIR)/$(XORG_SOURCE):
	$(WGET) -P $(DL_DIR) $(XORG_SITE)/$(XORG_SOURCE)

$(XORG_DIR)/.configure: $(DL_DIR)/$(XORG_SOURCE)
	$(XORG_CAT) $(DL_DIR)/$(XORG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(XORG_DIR) package/xorg/ xorg\*.patch
	$(SED) 's:REPLACE_STAGING_DIR:$(STAGING_DIR):g' $(XORG_CF)
	$(SED) 's:REPLACE_ARCH:$(ARCH):g' $(XORG_CF)
	$(SED) 's:#define CcCmd.*:#define CcCmd $(TARGET_CROSS)gcc:g' $(XORG_CF)
	$(SED) 's:#define RanlibCmd.*:#define RanlibCmd $(TARGET_CROSS)ranlib:g' $(XORG_CF)
	$(SED) 's:#define LdCmd.*:#define LdCmd $(TARGET_CROSS)ld:g' $(XORG_CF)
	touch $(XORG_DIR)/.configure

$(XORG_XSERVER): $(XORG_DIR)/.configure
	rm -f $(XORG_BINX)/Xfbdev
	( cd $(XORG_DIR) ; $(MAKE) World )

$(XORG_BINX)/Xfbdev: $(XORG_XSERVER)
	-mkdir $(TARGET_DIR)/usr/X11R6
	-mkdir $(XORG_BINX)
	for file in $(XORG_APPS) ; do \
		cp -f $(XORG_DIR)/programs/$$file $(XORG_BINX) ; \
		$(STRIP) $(XORG_PROGS)/$$file ; \
	done
	cp $(XORG_DIR)/programs/Xserver/Xfbdev $(XORG_BINX)
	$(STRIP) $(XORG_BINX)/Xfbdev
	cp -f $(XORG_DIR)/startx $(TARGET_DIR)/bin
	chmod a+x $(TARGET_DIR)/bin/startx

$(XORG_LIBX)/libX11.so.6.2: $(XORG_XSERVER)
	for dirs in $(XORG_LIBS) ; do \
		file=`find $(XORG_LDIR)/$$dirs -type f -iname "lib$$dirs.so*"` ; \
		$(STRIP) --strip-unneeded $$file ; \
		cp -f $$file $(XORG_LIBX) ; \
		file=`find $(XORG_LDIR)/$$dirs -type l -iname "lib$$dirs.so*"` ; \
		cp -pRf $$file $(XORG_LIBX) ; \
	done

xorg: zlib $(XORG_LIBX)/libX11.so.6.2 $(XORG_BINX)/Xfbdev

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
ifeq ($(strip $(BR2_PACKAGE_XORG)),y)
TARGETS+=xorg
endif

endif
