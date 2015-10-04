################################################################################
#
# wine
#
################################################################################

WINE_VERSION = 1.6.2
WINE_SOURCE = wine-$(WINE_VERSION).tar.bz2
WINE_SITE = http://downloads.sourceforge.net/project/wine/Source
WINE_LICENSE = LGPLv2.1+
WINE_LICENSE_FILES = COPYING.LIB LICENSE
WINE_DEPENDENCIES = host-bison host-flex host-wine
# For 0002-detect-ncursesw.patch
WINE_AUTORECONF = YES

# Wine needs its own directory structure and tools for cross compiling
WINE_CONF_OPTS = \
	--with-wine-tools=../host-wine-$(WINE_VERSION) \
	--disable-tests \
	--disable-win64 \
	--without-capi \
	--without-coreaudio \
	--without-gettext \
	--without-gettextpo \
	--without-gphoto \
	--without-gsm \
	--without-hal \
	--without-openal \
	--without-opencl \
	--without-osmesa \
	--without-oss

# Wine uses a wrapper around gcc, and uses the value of --host to
# construct the filename of the gcc to call.  But for external
# toolchains, the GNU_TARGET_NAME tuple that we construct from our
# internal variables may differ from the actual gcc prefix for the
# external toolchains. So, we have to override whatever the gcc
# wrapper believes what the real gcc is named, and force the tuple of
# the external toolchain, not the one we compute in GNU_TARGET_NAME.
ifeq ($(BR2_TOOLCHAIN_EXTERNAL),y)
WINE_CONF_OPTS += TARGETFLAGS="-b $(call qstrip,$(BR2_TOOLCHAIN_EXTERNAL_PREFIX))"
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB)$(BR2_PACKAGE_ALSA_LIB_SEQ)$(BR2_PACKAGE_ALSA_LIB_RAWMIDI),yyy)
WINE_CONF_OPTS += --with-alsa
WINE_DEPENDENCIES += alsa-lib
else
WINE_CONF_OPTS += --without-alsa
endif

ifeq ($(BR2_PACKAGE_CUPS),y)
WINE_CONF_OPTS += --with-cups
WINE_DEPENDENCIES += cups
else
WINE_CONF_OPTS += --without-cups
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
WINE_CONF_OPTS += --with-dbus
WINE_DEPENDENCIES += dbus
else
WINE_CONF_OPTS += --without-dbus
endif

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
WINE_CONF_OPTS += --with-fontconfig
WINE_DEPENDENCIES += fontconfig
else
WINE_CONF_OPTS += --without-fontconfig
endif

# To support freetype in wine we also need freetype in host-wine for the cross compiling tools
ifeq ($(BR2_PACKAGE_FREETYPE),y)
WINE_CONF_OPTS += --with-freetype
HOST_WINE_CONF_OPTS += --with-freetype
WINE_DEPENDENCIES += freetype
HOST_WINE_DEPENDENCIES += host-freetype
else
WINE_CONF_OPTS += --without-freetype
HOST_WINE_CONF_OPTS += --without-freetype
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
WINE_CONF_OPTS += --with-gnutls
WINE_DEPENDENCIES += gnutls
else
WINE_CONF_OPTS += --without-gnutls
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE),y)
WINE_CONF_OPTS += --with-gstreamer
WINE_DEPENDENCIES += gst-plugins-base
else
WINE_CONF_OPTS += --without-gstreamer
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
WINE_CONF_OPTS += --with-jpeg
WINE_DEPENDENCIES += jpeg
else
WINE_CONF_OPTS += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_LCMS2),y)
WINE_CONF_OPTS += --with-cms
WINE_DEPENDENCIES += lcms2
else
WINE_CONF_OPTS += --without-cms
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
WINE_CONF_OPTS += --with-opengl
WINE_DEPENDENCIES += libgl
else
WINE_CONF_OPTS += --without-opengl
endif

ifeq ($(BR2_PACKAGE_LIBGLU),y)
WINE_CONF_OPTS += --with-glu
WINE_DEPENDENCIES += libglu
else
WINE_CONF_OPTS += --without-glu
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
WINE_CONF_OPTS += --with-png
WINE_DEPENDENCIES += libpng
else
WINE_CONF_OPTS += --without-png
endif

ifeq ($(BR2_PACKAGE_LIBV4L),y)
WINE_CONF_OPTS += --with-v4l
WINE_DEPENDENCIES += libv4l
else
WINE_CONF_OPTS += --without-v4l
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
WINE_CONF_OPTS += --with-xml
WINE_DEPENDENCIES += libxml2
else
WINE_CONF_OPTS += --without-xml
endif

ifeq ($(BR2_PACKAGE_LIBXSLT),y)
WINE_CONF_OPTS += --with-xslt
WINE_DEPENDENCIES += libxslt
else
WINE_CONF_OPTS += --without-xslt
endif

ifeq ($(BR2_PACKAGE_MPG123),y)
WINE_CONF_OPTS += --with-mpg123
WINE_DEPENDENCIES += mpg123
else
WINE_CONF_OPTS += --without-mpg123
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
WINE_CONF_OPTS += --with-curses
WINE_DEPENDENCIES += ncurses
else
WINE_CONF_OPTS += --without-curses
endif

ifeq ($(BR2_PACKAGE_OPENLDAP),y)
WINE_CONF_OPTS += --with-ldap
WINE_DEPENDENCIES += openldap
else
WINE_CONF_OPTS += --without-ldap
endif

ifeq ($(BR2_PACKAGE_SANE_BACKENDS),y)
WINE_CONF_OPTS += --with-sane
WINE_DEPENDENCIES += sane-backends
WINE_CONF_ENV += SANE_CONFIG=$(STAGING_DIR)/usr/bin/sane-config
else
WINE_CONF_OPTS += --without-sane
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
WINE_CONF_OPTS += --with-tiff
WINE_DEPENDENCIES += tiff
else
WINE_CONF_OPTS += --without-tiff
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
WINE_CONF_OPTS += --with-x
WINE_DEPENDENCIES += xlib_libX11
else
WINE_CONF_OPTS += --without-x
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCOMPOSITE),y)
WINE_CONF_OPTS += --with-xcomposite
WINE_DEPENDENCIES += xlib_libXcomposite
else
WINE_CONF_OPTS += --without-xcomposite
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCURSOR),y)
WINE_CONF_OPTS += --with-xcursor
WINE_DEPENDENCIES += xlib_libXcursor
else
WINE_CONF_OPTS += --without-xcursor
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXEXT),y)
WINE_CONF_OPTS += --with-xshape --with-xshm
WINE_DEPENDENCIES += xlib_libXext
else
WINE_CONF_OPTS += --without-xshape --without-xshm
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXI),y)
WINE_CONF_OPTS += --with-xinput --with-xinput2
WINE_DEPENDENCIES += xlib_libXi
else
WINE_CONF_OPTS += --without-xinput --without-xinput2
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
WINE_CONF_OPTS += --with-xinerama
WINE_DEPENDENCIES += xlib_libXinerama
else
WINE_CONF_OPTS += --without-xinerama
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
WINE_CONF_OPTS += --with-xrandr
WINE_DEPENDENCIES += xlib_libXrandr
else
WINE_CONF_OPTS += --without-xrandr
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRENDER),y)
WINE_CONF_OPTS += --with-xrender
WINE_DEPENDENCIES += xlib_libXrender
else
WINE_CONF_OPTS += --without-xrender
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXXF86VM),y)
WINE_CONF_OPTS += --with-xxf86vm
WINE_DEPENDENCIES += xlib_libXxf86vm
else
WINE_CONF_OPTS += --without-xxf86vm
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
WINE_CONF_OPTS += --with-zlib
WINE_DEPENDENCIES += zlib
else
WINE_CONF_OPTS += --without-zlib
endif

# host-gettext is essential for .po file support in host-wine wrc
HOST_WINE_DEPENDENCIES += host-gettext
HOST_WINE_CONF_OPTS += --with-gettext --with-gettextpo

# Wine needs to enable 64-bit build tools on 64-bit host
ifeq ($(HOSTARCH),x86_64)
HOST_WINE_CONF_OPTS += --enable-win64
endif

# Wine only needs the host tools to be built, so cut-down the
# build time by building just what we need.
define HOST_WINE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) \
	  tools \
	  tools/widl \
	  tools/winebuild \
	  tools/winegcc \
	  tools/wmc \
	  tools/wrc
endef

# Wine only needs its host variant to be built, not that it is
# installed, as it uses the tools from the build directory. But
# we have no way in Buildroot to state that a host package should
# not be installed. So, just provide an noop install command.
define HOST_WINE_INSTALL_CMDS
	:
endef

# We are focused on the cross compiling tools, disable everything else
HOST_WINE_CONF_OPTS += \
	--disable-tests \
	--disable-win16 \
	--without-alsa \
	--without-capi \
	--without-cms \
	--without-coreaudio \
	--without-cups \
	--without-curses \
	--without-dbus \
	--without-fontconfig \
	--without-gphoto \
	--without-glu \
	--without-gnutls \
	--without-gsm \
	--without-gstreamer \
	--without-hal \
	--without-jpeg \
	--without-ldap \
	--without-mpg123 \
	--without-openal \
	--without-opencl \
	--without-opengl \
	--without-osmesa \
	--without-oss \
	--without-png \
	--without-sane \
	--without-tiff \
	--without-v4l \
	--without-x \
	--without-xcomposite \
	--without-xcursor \
	--without-xinerama \
	--without-xinput \
	--without-xinput2 \
	--without-xml \
	--without-xrandr \
	--without-xrender \
	--without-xshape \
	--without-xshm \
	--without-xslt \
	--without-xxf86vm \
	--without-zlib

$(eval $(autotools-package))
$(eval $(host-autotools-package))
