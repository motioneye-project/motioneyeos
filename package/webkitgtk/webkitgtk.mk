################################################################################
#
# webkitgtk
#
################################################################################

WEBKITGTK_VERSION = 2.28.3
WEBKITGTK_SITE = https://www.webkitgtk.org/releases
WEBKITGTK_SOURCE = webkitgtk-$(WEBKITGTK_VERSION).tar.xz
WEBKITGTK_INSTALL_STAGING = YES
WEBKITGTK_LICENSE = LGPL-2.1+, BSD-2-Clause
WEBKITGTK_LICENSE_FILES = \
	Source/WebCore/LICENSE-APPLE \
	Source/WebCore/LICENSE-LGPL-2.1
WEBKITGTK_DEPENDENCIES = host-ruby host-python host-gperf \
	enchant harfbuzz icu jpeg libgcrypt libgtk3 libsecret libsoup \
	libtasn1 libxml2 libxslt openjpeg sqlite webp woff2
WEBKITGTK_CONF_OPTS = \
	-DENABLE_API_TESTS=OFF \
	-DENABLE_GEOLOCATION=OFF \
	-DENABLE_GTKDOC=OFF \
	-DENABLE_INTROSPECTION=OFF \
	-DENABLE_MINIBROWSER=ON \
	-DENABLE_SPELLCHECK=ON \
	-DPORT=GTK \
	-DSILENCE_CROSS_COMPILATION_NOTICES=ON \
	-DUSE_LIBNOTIFY=OFF \
	-DUSE_LIBHYPHEN=OFF \
	-DUSE_OPENJPEG=ON \
	-DUSE_WOFF2=ON \
	-DUSE_WPE_RENDERER=OFF

ifeq ($(BR2_PACKAGE_WEBKITGTK_SANDBOX),y)
WEBKITGTK_CONF_OPTS += \
	-DENABLE_BUBBLEWRAP_SANDBOX=ON \
	-DBWRAP_EXECUTABLE=/usr/bin/bwrap \
	-DDBUS_PROXY_EXECUTABLE=/usr/bin/xdg-dbus-proxy
WEBKITGTK_DEPENDENCIES += libseccomp
else
WEBKITGTK_CONF_OPTS += -DENABLE_BUBBLEWRAP_SANDBOX=OFF
endif

ifeq ($(BR2_PACKAGE_WEBKITGTK_MULTIMEDIA),y)
WEBKITGTK_CONF_OPTS += \
	-DENABLE_VIDEO=ON \
	-DENABLE_WEB_AUDIO=ON
WEBKITGTK_DEPENDENCIES += gstreamer1 gst1-libav gst1-plugins-base gst1-plugins-good
else
WEBKITGTK_CONF_OPTS += \
	-DENABLE_VIDEO=OFF \
	-DENABLE_WEB_AUDIO=OFF
endif

ifeq ($(BR2_PACKAGE_WEBKITGTK_WEBDRIVER),y)
WEBKITGTK_CONF_OPTS += -DENABLE_WEBDRIVER=ON
else
WEBKITGTK_CONF_OPTS += -DENABLE_WEBDRIVER=OFF
endif

# Only one target platform can be built, assume X11 > Wayland

# GTK3-X11 target gives OpenGL from newer libgtk3 versions
# Consider this better than EGL + maybe GLESv2 since both can't be built
# 2D CANVAS acceleration requires OpenGL proper with cairo-gl
ifeq ($(BR2_PACKAGE_LIBGTK3_X11),y)
WEBKITGTK_CONF_OPTS += \
	-DENABLE_ACCELERATED_2D_CANVAS=ON \
	-DENABLE_GLES2=OFF \
	-DENABLE_OPENGL=ON \
	-DENABLE_X11_TARGET=ON
WEBKITGTK_DEPENDENCIES += libgl \
	xlib_libXcomposite xlib_libXdamage xlib_libXrender xlib_libXt
# It can use libgtk2 for npapi plugins
ifeq ($(BR2_PACKAGE_LIBGTK2),y)
WEBKITGTK_CONF_OPTS += -DENABLE_PLUGIN_PROCESS_GTK2=ON
WEBKITGTK_DEPENDENCIES += libgtk2
else
WEBKITGTK_CONF_OPTS += -DENABLE_PLUGIN_PROCESS_GTK2=OFF
endif
else # !X11
# GTK3-BROADWAY/WAYLAND needs at least EGL
WEBKITGTK_DEPENDENCIES += libegl
# GLESv2 support is optional though
ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
WEBKITGTK_CONF_OPTS += \
	-DENABLE_GLES2=ON \
	-DENABLE_OPENGL=ON
WEBKITGTK_DEPENDENCIES += libgles
else
# Disable general OpenGL (shading) if there's no GLESv2
WEBKITGTK_CONF_OPTS += \
	-DENABLE_GLES2=OFF \
	-DENABLE_OPENGL=OFF
endif
# We must explicitly state the wayland target
ifeq ($(BR2_PACKAGE_LIBGTK3_WAYLAND),y)
WEBKITGTK_CONF_OPTS += -DENABLE_WAYLAND_TARGET=ON
endif
endif

ifeq ($(BR2_PACKAGE_WEBKITGTK_USE_GSTREAMER_GL),y)
WEBKITGTK_CONF_OPTS += -DUSE_GSTREAMER_GL=ON
else
WEBKITGTK_CONF_OPTS += -DUSE_GSTREAMER_GL=OFF
endif

# JIT is not supported for MIPS r6, but the WebKit build system does not
# have a check for these processors. Disable JIT forcibly here and use
# the CLoop interpreter instead.
#
# Upstream bug: https://bugs.webkit.org/show_bug.cgi?id=191258
ifeq ($(BR2_MIPS_CPU_MIPS32R6)$(BR2_MIPS_CPU_MIPS64R6),y)
WEBKITGTK_CONF_OPTS += -DENABLE_JIT=OFF -DENABLE_C_LOOP=ON
endif

$(eval $(cmake-package))
