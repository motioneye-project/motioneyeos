################################################################################
#
# gd
#
################################################################################

GD_VERSION = 2.1.0
GD_SOURCE = libgd-$(GD_VERSION).tar.xz
GD_SITE = https://bitbucket.org/libgd/gd-libgd/downloads/
GD_INSTALL_STAGING = YES
GD_LICENSE = GD license
GD_LICENSE_FILES = COPYING

GD_CONFIG_SCRIPTS = gdlib-config
GD_CONF_OPT = --without-x --disable-rpath

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
GD_DEPENDENCIES += fontconfig
GD_CONF_OPT += --with-fontconfig
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
GD_DEPENDENCIES += freetype
GD_CONF_OPT += --with-freetype=$(STAGING_DIR)/usr
else
GD_CONF_OPT += --without-freetype
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
GD_DEPENDENCIES += jpeg
GD_CONF_OPT += --with-jpeg
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
GD_DEPENDENCIES += libpng
GD_CONF_OPT += --with-png=$(STAGING_DIR)/usr
else
GD_CONF_OPT += --without-png
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXPM),y)
GD_DEPENDENCIES += xlib_libXpm
GD_CONF_OPT += --with-xpm
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
GD_DEPENDENCIES += zlib
endif

GD_TOOLS_$(BR2_PACKAGE_GD_ANNOTATE)	+= annotate
GD_TOOLS_$(BR2_PACKAGE_GD_BDFTOGD)	+= bdftogd
GD_TOOLS_$(BR2_PACKAGE_GD_GD2COPYPAL)	+= gd2copypal
GD_TOOLS_$(BR2_PACKAGE_GD_GD2TOGIF)	+= gd2togif
GD_TOOLS_$(BR2_PACKAGE_GD_GD2TOPNG)	+= gd2topng
GD_TOOLS_$(BR2_PACKAGE_GD_GDCMPGIF)	+= gdcmpgif
GD_TOOLS_$(BR2_PACKAGE_GD_GDPARTTOPNG)	+= gdparttopng
GD_TOOLS_$(BR2_PACKAGE_GD_GDTOPNG)	+= gdtopng
GD_TOOLS_$(BR2_PACKAGE_GD_GIFTOGD2)	+= giftogd2
GD_TOOLS_$(BR2_PACKAGE_GD_PNGTOGD)	+= pngtogd
GD_TOOLS_$(BR2_PACKAGE_GD_PNGTOGD2)	+= pngtogd2
GD_TOOLS_$(BR2_PACKAGE_GD_WEBPNG)	+= webpng

define GD_REMOVE_TOOLS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,$(GD_TOOLS_))
endef

GD_POST_INSTALL_TARGET_HOOKS += GD_REMOVE_TOOLS

$(eval $(autotools-package))
