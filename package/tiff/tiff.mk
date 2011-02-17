#############################################################
#
# tiff
#
#############################################################
TIFF_VERSION:=3.9.4
TIFF_SITE:=ftp://ftp.remotesensing.org/pub/libtiff
TIFF_SOURCE:=tiff-$(TIFF_VERSION).tar.gz
TIFF_INSTALL_STAGING = YES
TIFF_INSTALL_TARGET = YES
TIFF_CONF_OPT = \
	--enable-shared \
	--enable-static \
	--disable-cxx \
	--without-x \

TIFF_DEPENDENCIES = host-pkg-config zlib jpeg

define TIFF_INSTALL_TARGET_CMDS
	-cp -a $(@D)/libtiff/.libs/libtiff.so* $(TARGET_DIR)/usr/lib/
endef

$(eval $(call AUTOTARGETS,package,tiff))
