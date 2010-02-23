#############################################################
#
# imagemagick
#
#############################################################
IMAGEMAGICK_MAJOR:=6.4.8
IMAGEMAGICK_VERSION:=$(IMAGEMAGICK_MAJOR)-4
IMAGEMAGICK_SOURCE:=ImageMagick-$(IMAGEMAGICK_VERSION).tar.bz2
IMAGEMAGICK_SITE:=ftp://ftp.imagemagick.org/pub/ImageMagick
IMAGEMAGICK_DIR:=$(BUILD_DIR)/ImageMagick-$(IMAGEMAGICK_VERSION)
IMAGEMAGICK_CAT:=$(BZCAT)
IMAGEMAGICK_LIB:=$(TARGET_DIR)/usr/lib/libMagickCore.so

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
	$(call DOWNLOAD,$(IMAGEMAGICK_SITE),$(IMAGEMAGICK_SOURCE))

$(IMAGEMAGICK_DIR)/.unpacked: $(DL_DIR)/$(IMAGEMAGICK_SOURCE)
	$(IMAGEMAGICK_CAT) $(DL_DIR)/$(IMAGEMAGICK_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(IMAGEMAGICK_DIR) package/imagemagick/ imagemagick-$(IMAGEMAGICK_VERSION)\*.patch\*
	$(CONFIG_UPDATE) $(IMAGEMAGICK_DIR)/config
	touch $@

ifeq ($(BR2_LARGEFILE),y)
IMAGEMAGICK_CONF_OPTS = ac_cv_sys_file_offset_bits=64
else
IMAGEMAGICK_CONF_OPTS = ac_cv_sys_file_offset_bits=32
endif

$(IMAGEMAGICK_DIR)/.configured: $(IMAGEMAGICK_DIR)/.unpacked
	(cd $(IMAGEMAGICK_DIR); rm -f config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure $(QUIET) \
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
		$(IMAGEMAGICK_CONF_OPTS) \
	)
	touch $@

$(IMAGEMAGICK_DIR)/.compiled: $(IMAGEMAGICK_DIR)/.configured
	$(MAKE) -C $(IMAGEMAGICK_DIR)
	touch $@

$(STAGING_DIR)/usr/lib/libMagickCore.a: $(IMAGEMAGICK_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(IMAGEMAGICK_DIR) install
	touch -c $@

$(IMAGEMAGICK_LIB): $(STAGING_DIR)/usr/lib/libMagickCore.a
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/lib/libMagickWand.so* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libMagickWand.so*
	mkdir -p $(TARGET_DIR)/usr/lib/ImageMagick-$(IMAGEMAGICK_MAJOR)
	$(IMAGEMAGICK_COPY) -r $(STAGING_DIR)/usr/lib/ImageMagick-$(IMAGEMAGICK_MAJOR) $(TARGET_DIR)/usr/lib
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/lib/libMagickCore.so* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(IMAGEMAGICK_LIB)*
	touch -c $@

$(IMAGEMAGICK_DIR)/.libinstall: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_DIR)/libtool --finish $(TARGET_DIR)/usr/lib/ImageMagick-$(IMAGEMAGICK_MAJOR)/modules-Q16/coders
	$(IMAGEMAGICK_DIR)/libtool --finish $(TARGET_DIR)/usr/lib/ImageMagick-$(IMAGEMAGICK_MAJOR)/modules-Q16/filters
	touch $@

$(TARGET_DIR)/usr/bin/animate: $(IMAGEMAGICK_LIB)
	ls -l $(IMAGEMAGICK_LIB) >> datefile
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-animate $(TARGET_DIR)/usr/bin/animate
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/animate
	touch $@

$(TARGET_DIR)/usr/bin/compare: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-compare $(TARGET_DIR)/usr/bin/compare
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/compare
	touch $@

$(TARGET_DIR)/usr/bin/composite: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-composite $(TARGET_DIR)/usr/bin/composite
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/composite
	touch $@

$(TARGET_DIR)/usr/bin/conjure: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-conjure $(TARGET_DIR)/usr/bin/conjure
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/conjure
	touch $@

$(TARGET_DIR)/usr/bin/display: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-display $(TARGET_DIR)/usr/bin/display
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/display
	touch $@

$(TARGET_DIR)/usr/bin/import: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-import $(TARGET_DIR)/usr/bin/import
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/import
	touch $@

$(TARGET_DIR)/usr/bin/mogrify: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-mogrify $(TARGET_DIR)/usr/bin/mogrify
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/mogrify
	touch $@

$(TARGET_DIR)/usr/bin/montage: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-montage $(TARGET_DIR)/usr/bin/montage
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/montage
	touch $@

$(TARGET_DIR)/usr/bin/convert: $(IMAGEMAGICK_LIB)
	$(IMAGEMAGICK_COPY) $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-convert $(TARGET_DIR)/usr/bin/convert
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/convert
	touch $@

imagemagick: jpeg tiff $(IMAGEMAGICK_LIB) \
		$(IMAGEMAGICK_DIR)/.libinstall \
		$(IMAGEMAGICK_TARGET_BINARIES)

imagemagick-source: $(DL_DIR)/$(IMAGEMAGICK_SOURCE)

imagemagick-unpacked:$(IMAGEMAGICK_DIR)/.unpacked

imagemagick-clean:
	for target_binary in $(IMAGEMAGICK_TARGET_BINARIES); do \
		rm -f $$target_binary; \
	done
	rm -rf $(TARGET_DIR)/usr/lib/libMagick*
	rm -rf $(TARGET_DIR)/usr/lib/ImageMagick-$(IMAGEMAGICK_MAJOR)
	-$(MAKE) -C $(IMAGEMAGICK_DIR) clean

imagemagick-dirclean:
	rm -rf $(IMAGEMAGICK_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_IMAGEMAGICK),y)
TARGETS+=imagemagick
endif
