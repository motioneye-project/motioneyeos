#############################################################
#
# MatchBox LIB
#
#############################################################

MATCHBOX_LIB_VERSION = 1.9
MATCHBOX_LIB_SOURCE = libmatchbox-$(MATCHBOX_LIB_VERSION).tar.bz2
MATCHBOX_LIB_SITE = http://matchbox-project.org/sources/libmatchbox/$(MATCHBOX_LIB_VERSION)
MATCHBOX_LIB_INSTALL_STAGING = YES
MATCHBOX_LIB_DEPENDENCIES = host-pkg-config expat xlib_libXext
MATCHBOX_LIB_CONF_OPT = --enable-expat --disable-doxygen-docs

define MATCHBOX_LIB_POST_INSTALL_FIXES
 $(SED) 's:-I[^$$].*/usr/include/freetype2:-I/usr/include/freetype2:' $(STAGING_DIR)/usr/lib/pkgconfig/libmb.pc
endef

MATCHBOX_LIB_POST_INSTALL_STAGING_HOOKS += MATCHBOX_LIB_POST_INSTALL_FIXES

#############################################################

ifeq ($(BR2_PACKAGE_X11R7_LIBXCOMPOSITE),y)
ifeq ($(BR2_PACKAGE_X11R7_LIBXPM),y)
  MATCHBOX_LIB_DEPENDENCIES+=xlib_libXpm
endif
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
  MATCHBOX_LIB_CONF_OPT+=--enable-jpeg
  MATCHBOX_LIB_DEPENDENCIES+=jpeg
else
  MATCHBOX_LIB_CONF_OPT+=--disable-jpeg
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
  MATCHBOX_LIB_CONF_OPT+=--enable-png
  MATCHBOX_LIB_DEPENDENCIES+=libpng
else
  MATCHBOX_LIB_CONF_OPT+=--disable-png
endif

ifeq ($(BR2_PACKAGE_PANGO),y)
  MATCHBOX_LIB_CONF_OPT+=--enable-pango
  MATCHBOX_LIB_DEPENDENCIES+=pango
else
  MATCHBOX_LIB_CONF_OPT+=--disable-pango
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFT),y)
  MATCHBOX_LIB_CONF_OPT+=--enable-xft
  MATCHBOX_LIB_DEPENDENCIES+=xlib_libXft
else
  MATCHBOX_LIB_CONF_OPT+=--disable-xft
endif

#############################################################

$(eval $(autotools-package))
