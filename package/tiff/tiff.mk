#############################################################
#
# tiff
#
#############################################################
TIFF_VERSION:=3.8.2
TIFF_SITE:=ftp://ftp.remotesensing.org/pub/libtiff
TIFF_SOURCE:=tiff-$(TIFF_VERSION).tar.gz
TIFF_LIBTOOL_PATCH = NO
TIFF_INSTALL_STAGING = YES
TIFF_INSTALL_TARGET = YES
TIFF_CONF_OPT = \
	--enable-shared \
	--enable-static \
	--disable-cxx \
	--without-x \

TIFF_DEPENDENCIES = uclibc pkgconfig zlib jpeg

$(eval $(call AUTOTARGETS,package,tiff))

$(TIFF_TARGET_INSTALL_TARGET):
	-cp -a $(TIFF_DIR)/libtiff/.libs/libtiff.so* $(TARGET_DIR)/usr/lib/
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libtiff.so
	touch $@

