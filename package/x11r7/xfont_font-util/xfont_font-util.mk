################################################################################
#
# font-util -- No description available
#
################################################################################

XFONT_FONT_UTIL_VERSION = 1.0.1
XFONT_FONT_UTIL_NAME = font-util-$(XFONT_FONT_UTIL_VERSION)
XFONT_FONT_UTIL_SOURCE = font-util-$(XFONT_FONT_UTIL_VERSION).tar.bz2
XFONT_FONT_UTIL_SITE = http://xorg.freedesktop.org/releases/individual/font
XFONT_FONT_UTIL_AUTORECONF = NO
XFONT_FONT_UTIL_DIR=$(BUILD_DIR)/$(XFONT_FONT_UTIL_NAME)
XFONT_FONT_UTIL_CAT:=$(BZCAT)

$(DL_DIR)/$(XFONT_FONT_UTIL_SOURCE):
	 $(WGET) -P $(DL_DIR) $(XFONT_FONT_UTIL_SITE)/$(XFONT_FONT_UTIL_SOURCE)

xfont_font-util-source: $(DL_DIR)/$(XFONT_FONT_UTIL_SOURCE)

$(XFONT_FONT_UTIL_DIR)/.unpacked: $(DL_DIR)/$(XFONT_FONT_UTIL_SOURCE)
	$(XFONT_FONT_UTIL_CAT) $(DL_DIR)/$(XFONT_FONT_UTIL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(XFONT_FONT_UTIL_DIR) package/x11r7/xfont_font-util/ \*.patch
	$(CONFIG_UPDATE) $(XFONT_FONT_UTIL_DIR)
	touch $@

$(XFONT_FONT_UTIL_DIR)/.configured: $(XFONT_FONT_UTIL_DIR)/.unpacked
	(cd $(XFONT_FONT_UTIL_DIR) && rm -rf config.cache)
	(cd $(XFONT_FONT_UTIL_DIR) && \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/usr/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/usr/include \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
	)
	touch $@

$(XFONT_FONT_UTIL_DIR)/.compiled: $(XFONT_FONT_UTIL_DIR)/.configured
	$(MAKE) -C $(XFONT_FONT_UTIL_DIR)
	touch $@

$(XFONT_FONT_UTIL_DIR)/.installed: $(XFONT_FONT_UTIL_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(XFONT_FONT_UTIL_DIR) install
	touch $@

$(XFONT_FONT_UTIL_DIR)/.hacked: $(XFONT_FONT_UTIL_DIR)/.installed
	( package/x11r7/xfont_font-util/post-install.sh $(STAGING_DIR) )
	touch $@

xfont_font-util: uclibc pkgconfig $(XFONT_FONT_UTIL_DIR)/.hacked

xfont_font-util-unpacked: $(XFONT_FONT_UTIL_DIR)/.unpacked

xfont_font-util-clean:
	-$(MAKE) -C $(XFONT_FONT_UTIL_DIR) clean

xfont_font-util-dirclean:
	rm -rf $(XFONT_FONT_UTIL_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_XFONT_FONT_UTIL),y)
TARGETS+=xfont_font-util
endif

