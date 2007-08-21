#############################################################
#
# imagemagick
#
#############################################################
IMAGEMAGICK_VERSION:=6.3.5
IMAGEMAGICK_SOURCE:=ImageMagick.tar.bz2
IMAGEMAGICK_SITE:=ftp://ftp.imagemagick.org/pub/ImageMagick
IMAGEMAGICK_DIR:=$(BUILD_DIR)/ImageMagick-$(IMAGEMAGICK_VERSION)
IMAGEMAGICK_CAT:=$(BZCAT)
#IMAGEMAGICK_BINARY:=convert
#IMAGEMAGICK_TARGET_BINARY:=usr/bin/$(IMAGEMAGICK_BINARY)
IMAGEMAGICK_LIB:=$(TARGET_DIR)/usr/lib/libMagick.so

IMAGEMAGICK_TARGET_BINARIES:=$(TARGET_DIR)/usr/bin/animate
IMAGEMAGICK_TARGET_BINARIES+=$(TARGET_DIR)/usr/bin/compare
IMAGEMAGICK_TARGET_BINARIES+=$(TARGET_DIR)/usr/bin/composite
IMAGEMAGICK_TARGET_BINARIES+=$(TARGET_DIR)/usr/bin/conjure
IMAGEMAGICK_TARGET_BINARIES+=$(TARGET_DIR)/usr/bin/display
IMAGEMAGICK_TARGET_BINARIES+=$(TARGET_DIR)/usr/bin/import
IMAGEMAGICK_TARGET_BINARIES+=$(TARGET_DIR)/usr/bin/mogrify
IMAGEMAGICK_TARGET_BINARIES+=$(TARGET_DIR)/usr/bin/montage
IMAGEMAGICK_TARGET_BINARIES+=$(TARGET_DIR)/usr/bin/convert

IMAGEMAGICK_COPY:=cp -df --preserve=mode,ownership
$(DL_DIR)/$(IMAGEMAGICK_SOURCE):
	$(WGET) -P $(DL_DIR) $(IMAGEMAGICK_SITE)/$(IMAGEMAGICK_SOURCE)

$(IMAGEMAGICK_DIR)/.unpacked: $(DL_DIR)/$(IMAGEMAGICK_SOURCE)
	$(IMAGEMAGICK_CAT) $(DL_DIR)/$(IMAGEMAGICK_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(IMAGEMAGICK_DIR) package/imagemagick/ imagemagick-\*.patch\*
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

$(IMAGEMAGICK_LIB): $(STAGING_DIR)/usr/lib/libMagick.a
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/lib/libWand.so* $(TARGET_DIR)/usr/lib/
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libWand.so*
	mkdir -p $(TARGET_DIR)/usr/lib/ImageMagick-$(IMAGEMAGICK_VERSION)
	$(IMAGEMAGICK_COPY) -r $(STAGING_DIR)/usr/lib/ImageMagick-$(IMAGEMAGICK_VERSION) $(TARGET_DIR)/usr/lib
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/lib/libMagick.so* $(TARGET_DIR)/usr/lib/
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(IMAGEMAGICK_LIB)*
	touch -c $@

$(IMAGEMAGICK_DIR)/.libinstall: $(IMAGEMAGICK_LIB)
	libtool	--finish $(TARGET_DIR)/usr/lib/ImageMagick-6.3.5/modules-Q16/coders
	libtool	--finish $(TARGET_DIR)/usr/lib/ImageMagick-6.3.5/modules-Q16/filters
	touch	$@

$(TARGET_DIR)/usr/bin/animate: $(IMAGEMAGICK_LIB)
	ls -l $(IMAGEMAGICK_LIB) >> datefile
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-animate $(TARGET_DIR)/usr/bin/animate
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/animate
	touch	$@

$(TARGET_DIR)/usr/bin/compare: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-compare $(TARGET_DIR)/usr/bin/compare
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/compare
	touch	$@

$(TARGET_DIR)/usr/bin/composite: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-composite $(TARGET_DIR)/usr/bin/composite
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/composite
	touch	$@

$(TARGET_DIR)/usr/bin/conjure: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-conjure $(TARGET_DIR)/usr/bin/conjure
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/conjure
	touch	$@

$(TARGET_DIR)/usr/bin/display: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-display $(TARGET_DIR)/usr/bin/display
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/display
	touch	$@

$(TARGET_DIR)/usr/bin/import: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-import $(TARGET_DIR)/usr/bin/import
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/import
	touch	$@

$(TARGET_DIR)/usr/bin/mogrify: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-mogrify $(TARGET_DIR)/usr/bin/mogrify
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/mogrify
	touch	$@

$(TARGET_DIR)/usr/bin/montage: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-montage $(TARGET_DIR)/usr/bin/montage
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/montage
	touch	$@

$(TARGET_DIR)/usr/bin/convert: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-convert $(TARGET_DIR)/usr/bin/convert
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/convert
	touch	$@

imagemagick: uclibc jpeg tiff $(IMAGEMAGICK_LIB) \
		$(IMAGEMAGICK_DIR)/.libinstall	\
		$(IMAGEMAGICK_TARGET_BINARIES)

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
