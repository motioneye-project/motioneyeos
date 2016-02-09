################################################################################
#
# webkitgtk 2.4.x
#
################################################################################

WEBKITGTK24_VERSION = 2.4.9
WEBKITGTK24_SITE = http://www.webkitgtk.org/releases
WEBKITGTK24_SOURCE = webkitgtk-$(WEBKITGTK24_VERSION).tar.xz
WEBKITGTK24_INSTALL_STAGING = YES
WEBKITGTK24_LICENSE = LGPLv2+, BSD-2c
WEBKITGTK24_LICENSE_FILES = \
	Source/WebCore/LICENSE-APPLE \
	Source/WebCore/LICENSE-LGPL-2
WEBKITGTK24_DEPENDENCIES = host-ruby host-flex host-bison host-gperf \
	host-pkgconf enchant harfbuzz icu jpeg libcurl libgtk2 \
	libsecret libsoup libxml2 libxslt sqlite webp

WEBKITGTK24_DEPENDENCIES += \
	$(if $(BR_PACKAGE_XLIB_LIBXCOMPOSITE),xlib_libXcomposite) \
	$(if $(BR_PACKAGE_XLIB_LIBXDAMAGE),xlib_libXdamage)

# make 3.81 loops into oblivion with numjobs > 1
ifneq ($(findstring x3.81,x$(RUNNING_MAKE_VERSION)),)
WEBKITGTK24_MAKE = $(MAKE1)
endif

# Give explicit path to icu-config to avoid host leakage
WEBKITGTK24_CONF_ENV = ac_cv_path_icu_config=$(STAGING_DIR)/usr/bin/icu-config

# Some 32-bit architectures need libatomic support for 64-bit ops
ifeq ($(BR2_i386)$(BR2_mips)$(BR2_mipsel)$(BR2_sh),y)
WEBKITGTK24_CONF_ENV += LIBS="-latomic"
endif

# dependency tracking is to avoid build issues in the GEN/WTF phase
WEBKITGTK24_CONF_OPTS = \
	--enable-dependency-tracking \
	--enable-spellcheck \
	--disable-geolocation \
	--disable-glibtest \
	--disable-gtk-doc-html \
	--disable-wayland-target

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE),y)
WEBKITGTK24_CONF_OPTS += \
	--enable-video \
	--enable-web-audio
WEBKITGTK24_DEPENDENCIES += gst1-plugins-good
else
WEBKITGTK24_CONF_OPTS += \
	--disable-video \
	--disable-web-audio
endif

# OpenGL
ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
WEBKITGTK24_CONF_OPTS += \
	--enable-accelerated-compositing  \
	--enable-glx \
	--enable-webgl \
	--disable-gles2
WEBKITGTK24_DEPENDENCIES += libgl
# EGL + GLES
else ifeq ($(BR2_PACKAGE_HAS_LIBEGL)$(BR2_PACKAGE_HAS_LIBGLES),yy)
WEBKITGTK24_CONF_OPTS += \
	--enable-accelerated-compositing \
	--enable-gles2 \
	--enable-webgl \
	--disable-glx
WEBKITGTK24_DEPENDENCIES += libegl libgles
# Some EGL/GLES implementations needs extra help (eg. rpi-userland)
WEBKITGTK24_CONF_ENV += CPPFLAGS="$(TARGET_CPPFLAGS) \
	`$(PKG_CONFIG_HOST_BINARY) --cflags egl` \
	`$(PKG_CONFIG_HOST_BINARY) --clfags glesv2`"
# No GL
else
WEBKITGTK24_CONF_OPTS += \
	--disable-accelerated-compositing \
	--disable-gles2 \
	--disable-glx \
	--disable-webgl
endif

# X11 target with GTK2 (optionally GTK3)
ifeq ($(BR2_PACKAGE_XLIB_LIBXT),y)
WEBKITGTK24_CONF_OPTS += --enable-x11-target
WEBKITGTK24_DEPENDENCIES += xlib_libXt
else
WEBKITGTK24_CONF_OPTS += --disable-x11-target
endif

# ARM needs NEON for JIT
# i386 & x86_64 don't seem to have any special requirements
ifeq ($(BR2_ARM_CPU_HAS_NEON)$(BR2_i386)$(BR2_x86_64),y)
WEBKITGTK24_CONF_OPTS += --enable-jit
else
WEBKITGTK24_CONF_OPTS += --disable-jit
# Disabling assembly and JIT needs an extra push sometimes (ppc)
# See https://bugs.webkit.org/show_bug.cgi?format=multiple&id=113638
WEBKITGTK24_CONF_ENV += \
	CPPFLAGS="$(TARGET_CPPFLAGS) -DENABLE_JIT=0 -DENABLE_YARR_JIT=0 -DENABLE_ASSEMBLER=0"
endif

# webkit1 (old API) uses gtk2, webkit2 (new API) uses gtk3
# Both can be built simultaneously, prefer "newer" for size/time savings
# gtk2 is mandatory for plugin support
ifeq ($(BR2_PACKAGE_LIBGTK3_X11),y)
WEBKITGTK24_CONF_OPTS += \
	--with-gtk=3.0 \
	--disable-webkit1
WEBKITGTK24_DEPENDENCIES += libgtk3
define WEBKITGTK24_INSTALL_BROWSER
	$(INSTALL) -D -m 0755 $(@D)/Programs/MiniBrowser \
		$(TARGET_DIR)/usr/bin/MiniBrowser
endef
WEBKITGTK24_POST_INSTALL_TARGET_HOOKS += WEBKITGTK24_INSTALL_BROWSER
else
WEBKITGTK24_CONF_OPTS += \
	--with-gtk=2.0 \
	--disable-webkit2
endif

$(eval $(autotools-package))
