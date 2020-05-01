################################################################################
#
# ghostscript
#
################################################################################

GHOSTSCRIPT_VERSION = 9.50
GHOSTSCRIPT_SITE = https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs$(subst .,,$(GHOSTSCRIPT_VERSION))
GHOSTSCRIPT_SOURCE = ghostscript-$(GHOSTSCRIPT_VERSION).tar.xz
GHOSTSCRIPT_LICENSE = AGPL-3.0
GHOSTSCRIPT_LICENSE_FILES = LICENSE
# 0001-Fix-cross-compilation-issue.patch
GHOSTSCRIPT_AUTORECONF = YES
GHOSTSCRIPT_DEPENDENCIES = \
	host-lcms2 \
	host-libjpeg \
	host-pkgconf \
	host-zlib \
	fontconfig \
	ghostscript-fonts \
	jpeg \
	lcms2 \
	libpng \
	tiff

# Ghostscript includes (old) copies of several libraries, delete them.
# Inspired by linuxfromscratch:
# http://www.linuxfromscratch.org/blfs/view/svn/pst/gs.html
define GHOSTSCRIPT_REMOVE_LIBS
	rm -rf $(@D)/freetype $(@D)/ijs $(@D)/jbig2dec $(@D)/jpeg \
		$(@D)/lcms2mt $(@D)/libpng $(@D)/openjpeg $(@D)/tiff \
		$(@D)/zlib
endef
GHOSTSCRIPT_POST_PATCH_HOOKS += GHOSTSCRIPT_REMOVE_LIBS

GHOSTSCRIPT_CONF_ENV = \
	CCAUX="$(HOSTCC)" \
	CFLAGSAUX="$(HOST_CFLAGS) $(HOST_LDFLAGS)"

GHOSTSCRIPT_CONF_OPTS = \
	--disable-compile-inits \
	--enable-fontconfig \
	--with-fontpath=/usr/share/fonts \
	--enable-freetype \
	--disable-gtk \
	--without-libpaper \
	--with-system-libtiff

ifeq ($(BR2_PACKAGE_JBIG2DEC),y)
GHOSTSCRIPT_DEPENDENCIES += jbig2dec
GHOSTSCRIPT_CONF_OPTS += --with-jbig2dec
else
GHOSTSCRIPT_CONF_OPTS += --without-jbig2dec
endif

ifeq ($(BR2_PACKAGE_LIBIDN),y)
GHOSTSCRIPT_DEPENDENCIES += libidn
GHOSTSCRIPT_CONF_OPTS += --with-libidn
else
GHOSTSCRIPT_CONF_OPTS += --without-libidn
endif

ifeq ($(BR2_PACKAGE_OPENJPEG),y)
GHOSTSCRIPT_DEPENDENCIES += openjpeg
GHOSTSCRIPT_CONF_OPTS += --enable-openjpeg
else
GHOSTSCRIPT_CONF_OPTS += --disable-openjpeg
endif

ifeq ($(BR2_PACKAGE_CUPS),y)
GHOSTSCRIPT_DEPENDENCIES += cups
GHOSTSCRIPT_CONF_OPTS  += \
	CUPSCONFIG=$(STAGING_DIR)/usr/bin/cups-config \
	--enable-cups
else
GHOSTSCRIPT_CONF_OPTS += --disable-cups
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
GHOSTSCRIPT_DEPENDENCIES += xlib_libX11
GHOSTSCRIPT_CONF_OPTS += --with-x
else
GHOSTSCRIPT_CONF_OPTS += --without-x
endif

$(eval $(autotools-package))
