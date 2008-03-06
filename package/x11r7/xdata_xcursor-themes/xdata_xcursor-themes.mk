#############################################################
#
# xdata_xcursor-themes - No description available
#
#############################################################
XDATA_XCURSOR_THEMES_VERSION:=1.0.1
XDATA_XCURSOR_THEMES_SOURCE:=xcursor-themes-$(XDATA_XCURSOR_THEMES_VERSION).tar.bz2
XDATA_XCURSOR_THEMES_SITE:=http://xorg.freedesktop.org/releases/individual/data
XDATA_XCURSOR_THEMES_DIR:=$(BUILD_DIR)/xcursor-themes-$(XDATA_XCURSOR_THEMES_VERSION)

$(DL_DIR)/$(XDATA_XCURSOR_THEMES_SOURCE):
	$(WGET) -P $(DL_DIR) $(XDATA_XCURSOR_THEMES_SITE)/$(XDATA_XCURSOR_THEMES_SOURCE)

$(XDATA_XCURSOR_THEMES_DIR)/.extracted: $(DL_DIR)/$(XDATA_XCURSOR_THEMES_SOURCE)
	$(BZCAT) $(DL_DIR)/$(XDATA_XCURSOR_THEMES_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(XDATA_XCURSOR_THEMES_DIR)/.patched: $(XDATA_XCURSOR_THEMES_DIR)/.extracted
	toolchain/patch-kernel.sh $(XDATA_XCURSOR_THEMES_DIR) package/x11r7/xdata_xcursor-themes/ xdata_xcursor-themes\*.patch
	touch $@

$(XDATA_XCURSOR_THEMES_DIR)/.configured: $(XDATA_XCURSOR_THEMES_DIR)/.patched
	(cd $(XDATA_XCURSOR_THEMES_DIR) && \
		aclocal -I. -I$(STAGING_DIR)/usr/share/aclocal --install && \
		autoconf -I$(STAGING_DIR)/usr/share/aclocal && \
		automake -ac && \
		rm -rf config.cache && \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		STAGING_DIR=$(STAGING_DIR) \
 \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--enable-shared \
		--disable-static \
		--disable-IPv6 \
		$(DISABLE_NLS) \
 \
	)
	touch $@

$(XDATA_XCURSOR_THEMES_DIR)/.built: $(XDATA_XCURSOR_THEMES_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) CXX=$(TARGET_CC) -C $(XDATA_XCURSOR_THEMES_DIR)
	touch $@

$(XDATA_XCURSOR_THEMES_DIR)/.installed: $(XDATA_XCURSOR_THEMES_DIR)/.built
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(XDATA_XCURSOR_THEMES_DIR) install-exec install-data
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(XDATA_XCURSOR_THEMES_DIR) install
#	toolchain/replace.sh $(STAGING_DIR)/usr/lib ".*\.la" "\(['= ]\)/usr" "\\1$(STAGING_DIR)/usr"
#	find $(TARGET_DIR)/usr -name '*.la' -print -delete
	ln -s -f ./redglass $(TARGET_DIR)/usr/share/icons/default
	cd
	touch $@

xdata_xcursor-themes-clean:
	$(MAKE) prefix=$(STAGING_DIR)/usr -C $(XDATA_XCURSOR_THEMES_DIR) uninstall
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(XDATA_XCURSOR_THEMES_DIR) uninstall
	-$(MAKE) -C $(XDATA_XCURSOR_THEMES_DIR) clean
	-rm $(XDATA_XCURSOR_THEMES_DIR)/.installed
	-rm $(XDATA_XCURSOR_THEMES_DIR)/.built

xdata_xcursor-themes-dirclean:
	rm -rf $(XDATA_XCURSOR_THEMES_DIR)

xdata_xcursor-themes-depends:
xdata_xcursor-themes-source: $(XDATA_XCURSOR_THEMES_DIR)/.extracted
xdata_xcursor-themes-patch: $(XDATA_XCURSOR_THEMES_DIR)/.patched
xdata_xcursor-themes-configure: $(XDATA_XCURSOR_THEMES_DIR)/.configured
xdata_xcursor-themes-build: $(XDATA_XCURSOR_THEMES_DIR)/.built

xdata_xcursor-themes: xdata_xcursor-themes-depends $(XDATA_XCURSOR_THEMES_DIR)/.installed

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_XDATA_XCURSOR_THEMES)),y)
TARGETS+=xdata_xcursor-themes
endif

# :mode=makefile:
