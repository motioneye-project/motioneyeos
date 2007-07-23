#############################################################
#
# imagemagick
#
#############################################################
IMAGEMAGICK_VERSION:=6.3.4
IMAGEMAGICK_SOURCE:=ImageMagick.tar.bz2
IMAGEMAGICK_SITE:=ftp://ftp.imagemagick.org/pub/ImageMagick
IMAGEMAGICK_DIR:=$(BUILD_DIR)/ImageMagick-$(IMAGEMAGICK_VERSION)
IMAGEMAGICK_CAT:=$(BZCAT)
IMAGEMAGICK_BINARY:=convert
IMAGEMAGICK_TARGET_BINARY:=usr/bin/$(IMAGEMAGICK_BINARY)

$(DL_DIR)/$(IMAGEMAGICK_SOURCE):
	$(WGET) -P $(DL_DIR) $(IMAGEMAGICK_SITE)/$(IMAGEMAGICK_SOURCE)

$(IMAGEMAGICK_DIR)/.unpacked: $(DL_DIR)/$(IMAGEMAGICK_SOURCE)
	$(IMAGEMAGICK_CAT) $(DL_DIR)/$(IMAGEMAGICK_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(IMAGEMAGICK_DIR) package/imagemagick/ imagemagick-$(IMAGEMAGICK_VERSION)\*.patch\*
	$(CONFIG_UPDATE) $(IMAGEMAGICK_DIR)/config
	touch $@

$(IMAGEMAGICK_DIR)/.configured: $(IMAGEMAGICK_DIR)/.unpacked
	(cd $(IMAGEMAGICK_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--without-perl \
		--without-wmf \
		--without-xml \
		--without-rsvg \
		--without-openexr \
		--without-jp2 \
		--without-jbig \
		--without-gvc \
		--without-djvu \
		--without-dps \
		--without-gslib \
		--without-fpx \
		--without-freetype \
		--without-x \
	);
	touch $@

$(IMAGEMAGICK_DIR)/.compiled: $(IMAGEMAGICK_DIR)/.configured
	$(MAKE) -C $(IMAGEMAGICK_DIR)
	touch $@

$(STAGING_DIR)/usr/lib/libMagick.a: $(IMAGEMAGICK_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(IMAGEMAGICK_DIR) install
	touch -c $@

$(TARGET_DIR)/usr/lib/libMagick.so: $(STAGING_DIR)/usr/lib/libMagick.a
	cp -dpf $(STAGING_DIR)/usr/lib/libMagick.so* $(TARGET_DIR)/usr/lib/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libMagick.so*
	cp -dpf $(STAGING_DIR)/usr/lib/libWand.so* $(TARGET_DIR)/usr/lib/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libWand.so*
	touch -c $@

$(TARGET_DIR)/$(IMAGEMAGICK_TARGET_BINARY): $(TARGET_DIR)/usr/lib/libMagick.so
	cp -dpf $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-animate $(TARGET_DIR)/usr/bin/animate
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/bin/animate
	cp -dpf $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-compare $(TARGET_DIR)/usr/bin/compare
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/bin/compare
	cp -dpf $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-composite $(TARGET_DIR)/usr/bin/composite
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/bin/composite
	cp -dpf $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-conjure $(TARGET_DIR)/usr/bin/conjure
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/bin/conjure
	cp -dpf $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-convert $(TARGET_DIR)/usr/bin/convert
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/bin/convert
	cp -dpf $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-display $(TARGET_DIR)/usr/bin/display
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/bin/display
	cp -dpf $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-import $(TARGET_DIR)/usr/bin/import
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/bin/import
	cp -dpf $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-mogrify $(TARGET_DIR)/usr/bin/mogrify
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/bin/mogrify
	cp -dpf $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-montage $(TARGET_DIR)/usr/bin/montage
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/bin/montage
	mkdir -p $(TARGET_DIR)/usr/lib/ImageMagick-$(IMAGEMAGICK_VERSION)
	cp -dpfr $(STAGING_DIR)/usr/lib/ImageMagick-$(IMAGEMAGICK_VERSION) $(TARGET_DIR)/usr/lib
	touch -c $@

imagemagick: uclibc jpeg tiff $(TARGET_DIR)/usr/lib/libMagick.so $(TARGET_DIR)/$(IMAGEMAGICK_TARGET_BINARY)

imagemagick-clean:
	rm -f $(TARGET_DIR)/$(IMAGEMAGICK_TARGET_BINARY)
	rm -f $(TARGET_DIR)/usr/bin/animate
	rm -f $(TARGET_DIR)/usr/bin/compare
	rm -f $(TARGET_DIR)/usr/bin/composite
	rm -f $(TARGET_DIR)/usr/bin/conjure
	rm -f $(TARGET_DIR)/usr/bin/convert
	rm -f $(TARGET_DIR)/usr/bin/display
	rm -f $(TARGET_DIR)/usr/bin/import
	rm -f $(TARGET_DIR)/usr/bin/mogrify
	rm -f $(TARGET_DIR)/usr/bin/montage
	rm -rf $(TARGET_DIR)/usr/lib/ImageMagick-$(IMAGEMAGICK_VERSION)
	rm -rf $(TARGET_DIR)/usr/lib/ImageMagick-$(IMAGEMAGICK_VERSION)
	-$(MAKE) -C $(IMAGEMAGICK_DIR) clean

imagemagick-dirclean:
	rm -rf $(IMAGEMAGICK_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_IMAGEMAGICK)),y)
TARGETS+=imagemagick
endif
