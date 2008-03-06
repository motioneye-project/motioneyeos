#############################################################
#
# xpdf
#
#############################################################
XPDF_VERSION = 3.02
XPDF_SOURCE = xpdf-$(XPDF_VERSION).tar.gz
XPDF_SITE = ftp://ftp.foolabs.com/pub/xpdf
XPDF_AUTORECONF = NO
XPDF_INSTALL_STAGING = NO
XPDF_INSTALL_TARGET = YES
XPDF_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

XPDF_CONF_OPT = --enable-multithreaded 

ifeq ($(BR2_SOFT_FLOAT),y)
	XPDF_CONF_OPT += --enable-fixedpoint
endif

ifneq ($(BR2_PACKAGE_XSERVER_none),y)
	XPDF_DEPENDENCIES += $(XSERVER) openmotif
	XPDF_CONF_OPT += --with-Xm-library=$(STAGING_DIR)/usr/lib --with-Xm-includes=$(STAGING_DIR)/usr/include/Xm \
					--with-x --with-freetype2-includes=$(STAGING_DIR)/usr/include \
					--with-freetype2-library=$(STAGING_DIR)/usr/lib CFLAGS="-I$(STAGING_DIR)/usr/include/freetype2" \
					CXXFLAGS="-I$(STAGING_DIR)/usr/include/freetype2" 
endif

XPDF_DEPENDENCIES = uclibc freetype

$(eval $(call AUTOTARGETS,package,xpdf))

