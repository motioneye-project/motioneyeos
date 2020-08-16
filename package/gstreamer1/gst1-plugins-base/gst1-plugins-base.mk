################################################################################
#
# gst1-plugins-base
#
################################################################################

GST1_PLUGINS_BASE_VERSION = 1.16.2
GST1_PLUGINS_BASE_SOURCE = gst-plugins-base-$(GST1_PLUGINS_BASE_VERSION).tar.xz
GST1_PLUGINS_BASE_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-base
GST1_PLUGINS_BASE_INSTALL_STAGING = YES
GST1_PLUGINS_BASE_LICENSE_FILES = COPYING
GST1_PLUGINS_BASE_LICENSE = LGPL-2.0+, LGPL-2.1+

GST1_PLUGINS_BASE_CONF_OPTS = \
	-Dexamples=disabled \
	-Dtests=disabled \
	-Dgobject-cast-checks=disabled \
	-Dglib-asserts=disabled \
	-Dglib-checks=disabled \
	-Dgtk_doc=disabled

# Options which require currently unpackaged libraries
GST1_PLUGINS_BASE_CONF_OPTS += \
	-Dcdparanoia=disabled \
	-Dlibvisual=disabled \
	-Diso-codes=disabled

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_INSTALL_TOOLS),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dtools=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dtools=disabled
endif

GST1_PLUGINS_BASE_DEPENDENCIES = gstreamer1 $(TARGET_NLS_DEPENDENCIES)

GST1_PLUGINS_BASE_LDFLAGS = $(TARGET_LDFLAGS) $(TARGET_NLS_LIBS)

# These plugins are listed in the order from ./configure --help

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dintrospection=enabled
GST1_PLUGINS_BASE_DEPENDENCIES += gobject-introspection
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dintrospection=disabled
endif

ifeq ($(BR2_PACKAGE_ORC),y)
GST1_PLUGINS_BASE_DEPENDENCIES += orc
GST1_PLUGINS_BASE_CONF_OPTS += -Dorc=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dorc=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_HAS_API),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dgl=enabled
ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_OPENGL),y)
GST1_PLUGINS_BASE_GL_API_LIST = opengl
GST1_PLUGINS_BASE_DEPENDENCIES += libgl libglu
endif
ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_GLES2),y)
GST1_PLUGINS_BASE_GL_API_LIST += gles2
GST1_PLUGINS_BASE_DEPENDENCIES += libgles
endif
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dgl=disabled
endif
GST1_PLUGINS_BASE_CONF_OPTS += -Dgl_api='$(subst $(space),$(comma),$(GST1_PLUGINS_BASE_GL_API_LIST))'

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_GLX),y)
GST1_PLUGINS_BASE_GL_PLATFORM_LIST += glx
GST1_PLUGINS_BASE_DEPENDENCIES += xorgproto xlib_libXrender
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_EGL),y)
GST1_PLUGINS_BASE_GL_PLATFORM_LIST += egl
GST1_PLUGINS_BASE_DEPENDENCIES += libegl
endif
GST1_PLUGINS_BASE_CONF_OPTS += -Dgl_platform='$(subst $(space),$(comma),$(GST1_PLUGINS_BASE_GL_PLATFORM_LIST))'

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_X11),y)
GST1_PLUGINS_BASE_WINSYS_LIST += x11
GST1_PLUGINS_BASE_DEPENDENCIES += xlib_libX11 xlib_libXext
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_WAYLAND),y)
GST1_PLUGINS_BASE_WINSYS_LIST += wayland
GST1_PLUGINS_BASE_DEPENDENCIES += wayland wayland-protocols
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_DISPMANX),y)
GST1_PLUGINS_BASE_WINSYS_LIST += dispmanx
GST1_PLUGINS_BASE_DEPENDENCIES += rpi-userland
endif
GST1_PLUGINS_BASE_CONF_OPTS += -Dgl_winsys='$(subst $(space),$(comma),$(GST1_PLUGINS_BASE_WINSYS_LIST))'

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_ADDER),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dadder=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dadder=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_APP),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dapp=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dapp=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_AUDIOCONVERT),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Daudioconvert=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Daudioconvert=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_AUDIOMIXER),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Daudiomixer=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Daudiomixer=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_AUDIORATE),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Daudiorate=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Daudiorate=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_AUDIOTESTSRC),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Daudiotestsrc=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Daudiotestsrc=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_COMPOSITOR),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dcompositor=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dcompositor=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_ENCODING),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dencoding=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dencoding=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_VIDEOCONVERT),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dvideoconvert=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dvideoconvert=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_GIO),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dgio=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dgio=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_OVERLAYCOMPOSITION),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Doverlaycomposition=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Doverlaycomposition=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_PLAYBACK),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dplayback=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dplayback=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_AUDIORESAMPLE),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Daudioresample=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Daudioresample=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_RAWPARSE),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Drawparse=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Drawparse=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_SUBPARSE),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dsubparse=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dsubparse=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_TCP),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dtcp=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dtcp=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_TYPEFIND),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dtypefind=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dtypefind=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_VIDEOTESTSRC),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dvideotestsrc=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dvideotestsrc=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_VIDEORATE),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dvideorate=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dvideorate=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_VIDEOSCALE),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dvideoscale=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dvideoscale=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_VOLUME),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dvolume=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dvolume=disabled
endif

# Zlib is checked for headers and is not an option.
ifeq ($(BR2_PACKAGE_ZLIB),y)
GST1_PLUGINS_BASE_DEPENDENCIES += zlib
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
GST1_PLUGINS_BASE_DEPENDENCIES += xlib_libX11 xlib_libXext xlib_libXv
GST1_PLUGINS_BASE_CONF_OPTS += \
	-Dx11=enabled \
	-Dxshm=enabled \
	-Dxvideo=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += \
	-Dx11=disabled \
	-Dxshm=disabled \
	-Dxvideo=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_ALSA),y)
GST1_PLUGINS_BASE_DEPENDENCIES += alsa-lib
GST1_PLUGINS_BASE_CONF_OPTS += -Dalsa=enabled
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dalsa=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_TREMOR),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dtremor=enabled
GST1_PLUGINS_BASE_DEPENDENCIES += tremor
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dtremor=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_OPUS),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dopus=enabled
GST1_PLUGINS_BASE_DEPENDENCIES += opus
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dopus=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_OGG),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dogg=enabled
GST1_PLUGINS_BASE_DEPENDENCIES += libogg
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dogg=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_PANGO),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dpango=enabled
GST1_PLUGINS_BASE_DEPENDENCIES += pango
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dpango=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_THEORA),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dtheora=enabled
GST1_PLUGINS_BASE_DEPENDENCIES += libtheora
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dtheora=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_VORBIS),y)
GST1_PLUGINS_BASE_CONF_OPTS += -Dvorbis=enabled
GST1_PLUGINS_BASE_DEPENDENCIES += libvorbis
else
GST1_PLUGINS_BASE_CONF_OPTS += -Dvorbis=disabled
endif

$(eval $(meson-package))
