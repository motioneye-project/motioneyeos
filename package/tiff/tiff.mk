#############################################################
#
# tiff
#
#############################################################
TIFF_VERSION = 4.0.1
TIFF_SITE = ftp://ftp.remotesensing.org/pub/libtiff
TIFF_SOURCE = tiff-$(TIFF_VERSION).tar.gz
TIFF_INSTALL_STAGING = YES
TIFF_CONF_OPT = \
	--disable-cxx \
	--without-x \

TIFF_DEPENDENCIES = host-pkg-config

TIFF_TOOLS_LIST =
ifeq ($(BR2_PACKAGE_TIFF_TIFF2PDF),y)
	TIFF_TOOLS_LIST += tiff2pdf
endif
ifeq ($(BR2_PACKAGE_TIFF_TIFFCP),y)
	TIFF_TOOLS_LIST += tiffcp
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

define TIFF_INSTALL_TARGET_CMDS
	-cp -a $(@D)/libtiff/.libs/libtiff.so* $(TARGET_DIR)/usr/lib/
	for i in $(TIFF_TOOLS_LIST); \
	do \
		$(INSTALL) -m 755 -D $(@D)/tools/$$i $(TARGET_DIR)/usr/bin/$$i; \
	done
endef

$(eval $(autotools-package))
