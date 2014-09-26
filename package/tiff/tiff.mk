################################################################################
#
# tiff
#
################################################################################

TIFF_VERSION = 4.0.3
TIFF_SITE = http://download.osgeo.org/libtiff
TIFF_LICENSE = tiff license
TIFF_LICENSE_FILES = COPYRIGHT
TIFF_INSTALL_STAGING = YES
TIFF_CONF_OPT = \
	--disable-cxx \
	--without-x \

TIFF_DEPENDENCIES = host-pkgconf

TIFF_TOOLS_TO_DELETE = \
	bmp2tiff \
	fax2ps \
	fax2tiff \
	gif2tiff \
	pal2rgb \
	ppm2tiff \
	ras2tiff \
	raw2tiff \
	rgb2ycbcr \
	thumbnail \
	tiff2bw \
	tiff2ps \
	tiff2rgba \
	tiffcmp \
	tiffcrop \
	tiffdither \
	tiffdump \
	tiffinfo \
	tiffmedian \
	tiffset \
	tiffsplit \

ifeq ($(BR2_PACKAGE_TIFF_TIFF2PDF),)
	TIFF_TOOLS_TO_DELETE += tiff2pdf
endif
ifeq ($(BR2_PACKAGE_TIFF_TIFFCP),)
	TIFF_TOOLS_TO_DELETE += tiffcp
endif

ifneq ($(BR2_PACKAGE_TIFF_CCITT),y)
	TIFF_CONF_OPT += --disable-ccitt
endif

ifneq ($(BR2_PACKAGE_TIFF_PACKBITS),y)
	TIFF_CONF_OPT += --disable-packbits
endif

ifneq ($(BR2_PACKAGE_TIFF_LZW),y)
	TIFF_CONF_OPT += --disable-lzw
endif

ifneq ($(BR2_PACKAGE_TIFF_THUNDER),y)
	TIFF_CONF_OPT += --disable-thunder
endif

ifneq ($(BR2_PACKAGE_TIFF_NEXT),y)
	TIFF_CONF_OPT += --disable-next
endif

ifneq ($(BR2_PACKAGE_TIFF_LOGLUV),y)
	TIFF_CONF_OPT += --disable-logluv
endif

ifneq ($(BR2_PACKAGE_TIFF_MDI),y)
	TIFF_CONF_OPT += --disable-mdi
endif

ifneq ($(BR2_PACKAGE_TIFF_ZLIB),y)
	TIFF_CONF_OPT += --disable-zlib
else
	TIFF_DEPENDENCIES += zlib
endif

ifneq ($(BR2_PACKAGE_TIFF_PIXARLOG),y)
	TIFF_CONF_OPT += --disable-pixarlog
endif

ifneq ($(BR2_PACKAGE_TIFF_JPEG),y)
	TIFF_CONF_OPT += --disable-jpeg
else
	TIFF_DEPENDENCIES += jpeg
endif

ifneq ($(BR2_PACKAGE_TIFF_OLD_JPEG),y)
	TIFF_CONF_OPT += --disable-old-jpeg
endif

ifneq ($(BR2_PACKAGE_TIFF_JBIG),y)
	TIFF_CONF_OPT += --disable-jbig
endif

define TIFF_REMOVE_TOOLS_FIXUP
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,$(TIFF_TOOLS_TO_DELETE))
endef

TIFF_POST_INSTALL_TARGET_HOOKS += TIFF_REMOVE_TOOLS_FIXUP

$(eval $(autotools-package))
