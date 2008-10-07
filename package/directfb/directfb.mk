#############################################################
#
# directfb
#
#############################################################
#DIRECTFB_VERSION:=0.9.25.1
#DIRECTFB_SITE:=http://www.directfb.org/downloads/Old
DIRECTFB_MAJOR:=1.2
DIRECTFB_VERSION:=1.2.6
DIRECTFB_SITE:=http://www.directfb.org/downloads/Core
DIRECTFB_SOURCE:=DirectFB-$(DIRECTFB_VERSION).tar.gz
DIRECTFB_CAT:=$(ZCAT)
DIRECTFB_DIR:=$(BUILD_DIR)/DirectFB-$(DIRECTFB_VERSION)
DIRECTFB_STAGING:=directfb-$(DIRECTFB_MAJOR)-0
DIRECTFB_BIN:=usr/lib/libdirectfb-$(DIRECTFB_MAJOR).so.0
DIRECTFB_DEP:=zlib

ifeq ($(BR2_PACKAGE_DIRECTFB_MULTI),y)
DIRECTFB_MULTI:=--enable-multi --enable-fusion
DIRECTFB_FUSION:=linux-fusion
else
DIRECTFB_MULTI:=
DIRECTFB_FUSION:=
endif
ifeq ($(BR2_PACKAGE_XSERVER),y)
DIRECTFB_X:=--enable-x11
else
DIRECTFB_X:=--disable-x11
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_UNIQUE),y)
DIRECTFB_UNIQUE:=--enable-unique
else
DIRECTFB_UNIQUE:=--disable-unique
endif

DIRECTFB_GFX:=
ifeq ($(BR2_PACKAGE_DIRECTFB_ATI128),y)
DIRECTFB_GFX+= ati128
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_CLE266),y)
DIRECTFB_GFX+= cle266
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_CYBER5K),y)
DIRECTFB_GFX+= cyber5k
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_MATROX),y)
DIRECTFB_GFX+= matrox
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_UNICHROME),y)
DIRECTFB_GFX+= unichrome
endif
ifeq ($(DIRECTFB_GFX),)
DIRECTFB_GFX:=none
else
comma:=,
empty:=
space:=$(empty) $(empty)
DIRECTFB_GFX:=$(subst $(space),$(comma),$(strip $(DIRECTFB_GFX)))
endif

DIRECTFB_INPUT:=
ifeq ($(BR2_PACKAGE_DIRECTFB_KEYBOARD),y)
DIRECTFB_INPUT+= keyboard
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_PS2MOUSE),y)
DIRECTFB_INPUT+= ps2mouse
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_SERIALMOUSE),y)
DIRECTFB_INPUT+= serialmouse
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_TSLIB),y)
DIRECTFB_INPUT+= tslib
DIRECTFB_DEP+= tslib
endif
ifeq ($(DIRECTFB_INPUT),)
DIRECTFB_INPUT:=none
else
comma:=,
empty:=
space:=$(empty) $(empty)
DIRECTFB_INPUT:=$(subst $(space),$(comma),$(strip $(DIRECTFB_INPUT)))
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_GIF),y)
DIRECTFB_GIF:=--enable-gif
else
DIRECTFB_GIF:=--disable-gif
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_PNG),y)
DIRECTFB_PNG:=--enable-png
DIRECTFB_DEP+= libpng
else
DIRECTFB_PNG:=--disable-png
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_JPEG),y)
DIRECTFB_JPEG:=--enable-jpeg
DIRECTFB_DEP+= jpeg
else
DIRECTFB_JPEG:=--disable-jpeg
endif

$(DL_DIR)/$(DIRECTFB_SOURCE):
	$(WGET) -P $(DL_DIR) $(DIRECTFB_SITE)/$(DIRECTFB_SOURCE)

directfb-source: $(DL_DIR)/$(DIRECTFB_SOURCE)

$(DIRECTFB_DIR)/.unpacked: $(DL_DIR)/$(DIRECTFB_SOURCE)
	$(DIRECTFB_CAT) $(DL_DIR)/$(DIRECTFB_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(DIRECTFB_DIR) package/directfb/ directfb\*.patch
	touch $@

$(DIRECTFB_DIR)/.configured: $(DIRECTFB_DIR)/.unpacked
	(cd $(DIRECTFB_DIR); rm -f config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
	ac_cv_header_linux_wm97xx_h=no \
	ac_cv_header_linux_sisfb_h=no \
	ac_cv_header_asm_page_h=no \
	./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--with-gfxdrivers=$(DIRECTFB_GFX) \
		--with-inputdrivers=$(DIRECTFB_INPUT) \
		--enable-static \
		--enable-shared \
		$(DIRECTFB_MULTI) \
		$(DIRECTFB_X) \
		$(DIRECTFB_JPEG) \
		$(DIRECTFB_PNG) \
		$(DIRECTFB_GIF) \
		$(DIRECTFB_UNIQUE) \
		--enable-linux-input \
		--enable-zlib \
		--enable-freetype \
		--enable-fbdev \
		--disable-sysfs \
		--disable-sdl \
		--disable-vnc \
		--disable-video4linux \
		--disable-video4linux2 )
	touch $@

$(DIRECTFB_DIR)/.compiled: $(DIRECTFB_DIR)/.configured
	$(MAKE) PATH=$(STAGING_DIR)/usr/lib:$(PATH) \
		$(TARGET_CONFIGURE_OPTS) \
		-C $(DIRECTFB_DIR)
	touch $(DIRECTFB_DIR)/.compiled

$(STAGING_DIR)/$(DIRECTFB_BIN): $(DIRECTFB_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(DIRECTFB_DIR) install
	$(SED) "s, /usr/lib, $(STAGING_DIR)/usr/lib,g" \
		$(STAGING_DIR)/usr/lib/libdirect.la \
		$(STAGING_DIR)/usr/lib/libdirectfb.la \
		$(STAGING_DIR)/usr/lib/libfusion.la \
		`find $(STAGING_DIR)/usr/lib/directfb-$(DIRECTFB_MAJOR)-0/ -name '*.la'`
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" \
		$(STAGING_DIR)/usr/bin/*directfb-config

$(TARGET_DIR)/$(DIRECTFB_BIN): $(STAGING_DIR)/$(DIRECTFB_BIN)
	cd $(STAGING_DIR)/usr/lib/; find $(DIRECTFB_STAGING) -type f -name '*.so' \
		| xargs -IREPL install -Dm644 REPL $(TARGET_DIR)/usr/lib/REPL
	mkdir -p $(TARGET_DIR)/usr/lib/directfb-$(DIRECTFB_MAJOR)-0/gfxdrivers
	cp -dpf $(STAGING_DIR)/usr/lib/libfusion*.so.* $(TARGET_DIR)/usr/lib/
ifeq ($(BR2_PACKAGE_DIRECTFB_UNIQUE),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libuniquewm*.so.* $(TARGET_DIR)/usr/lib/
endif
	cp -dpf $(STAGING_DIR)/usr/lib/libdirect*.so.* $(TARGET_DIR)/usr/lib/
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) \
		$(TARGET_DIR)/usr/lib/libdirect*.so.* \
		$(TARGET_DIR)/usr/lib/libfusion*.so.*
ifeq ($(BR2_PACKAGE_DIRECTFB_UNIQUE),y)
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) \
		$(TARGET_DIR)/usr/lib/libuniquewm*.so.*
endif

directfb: uclibc $(DIRECTFB_DEP) freetype $(DIRECTFB_FUSION) $(TARGET_DIR)/$(DIRECTFB_BIN)

directfb-clean:
	-$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(DIRECTFB_DIR) uninstall
	-$(MAKE) -C $(DIRECTFB_DIR) clean
	rm -f $(DIRECTFB_DIR)/.configured $(DIRECTFB_DIR)/.compiled

directfb-dirclean:
	rm -rf $(DIRECTFB_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_DIRECTFB)),y)
TARGETS+=directfb
endif
