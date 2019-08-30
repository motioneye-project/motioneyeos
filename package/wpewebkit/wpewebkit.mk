################################################################################
#
# wpewebkit
#
################################################################################

WPEWEBKIT_VERSION = 2.24.3
WPEWEBKIT_SITE = http://www.wpewebkit.org/releases
WPEWEBKIT_SOURCE = wpewebkit-$(WPEWEBKIT_VERSION).tar.xz
WPEWEBKIT_INSTALL_STAGING = YES
WPEWEBKIT_LICENSE = LGPL-2.1+, BSD-2-Clause
WPEWEBKIT_LICENSE_FILES = \
	Source/WebCore/LICENSE-APPLE \
	Source/WebCore/LICENSE-LGPL-2.1
WPEWEBKIT_DEPENDENCIES = host-gperf host-python host-ruby \
	harfbuzz cairo icu jpeg libepoxy libgcrypt libgles libsoup libtasn1 \
	libpng libxslt openjpeg wayland-protocols webp wpebackend-fdo

WPEWEBKIT_CONF_OPTS = \
	-DPORT=WPE \
	-DENABLE_API_TESTS=OFF \
	-DENABLE_MINIBROWSER=OFF

ifeq ($(BR2_PACKAGE_WPEWEBKIT_MULTIMEDIA),y)
WPEWEBKIT_CONF_OPTS += \
	-DENABLE_VIDEO=ON \
	-DENABLE_WEB_AUDIO=ON
WPEWEBKIT_DEPENDENCIES += gstreamer1 gst1-libav gst1-plugins-base gst1-plugins-good
else
WPEWEBKIT_CONF_OPTS += \
	-DENABLE_VIDEO=OFF \
	-DENABLE_WEB_AUDIO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_GSTREAMER_GL),y)
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_GL=ON
else
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_GL=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_WEBDRIVER),y)
WPEWEBKIT_CONF_OPTS += -DENABLE_WEBDRIVER=ON
else
WPEWEBKIT_CONF_OPTS += -DENABLE_WEBDRIVER=OFF
endif

ifeq ($(BR2_PACKAGE_WOFF2),y)
WPEWEBKIT_CONF_OPTS += -DUSE_WOFF2=ON
WPEWEBKIT_DEPENDENCIES += woff2
else
WPEWEBKIT_CONF_OPTS += -DUSE_WOFF2=OFF
endif

$(eval $(cmake-package))
