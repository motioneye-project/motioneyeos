################################################################################
#
# qt5webengine
#
################################################################################

QT5WEBENGINE_VERSION = $(QT5_VERSION)
QT5WEBENGINE_SITE = $(QT5_SITE)
QT5WEBENGINE_SOURCE = qtwebengine-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5WEBENGINE_VERSION).tar.xz
QT5WEBENGINE_DEPENDENCIES = ffmpeg libglib2 libvpx opus webp \
	qt5declarative qt5webchannel host-bison host-flex host-gperf \
	host-pkgconf host-python
QT5WEBENGINE_INSTALL_STAGING = YES

include package/qt5/qt5webengine/chromium-latest.inc

QT5WEBENGINE_LICENSE = GPL-2.0 or LGPL-3.0 or GPL-3.0 or GPL-3.0 with exception
QT5WEBENGINE_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT \
	LICENSE.GPLv3 LICENSE.LGPL3 $(QT5WEBENGINE_CHROMIUM_LICENSE_FILES)

ifeq ($(BR2_PACKAGE_QT5BASE_XCB),y)
QT5WEBENGINE_DEPENDENCIES += xlib_libXScrnSaver xlib_libXcomposite \
	xlib_libXcursor xlib_libXi xlib_libXrandr xlib_libXtst
endif

QT5WEBENGINE_DEPENDENCIES += host-libpng host-libnss libnss

QT5WEBENGINE_CONF_OPTS += WEBENGINE_CONFIG+=use_system_ffmpeg

ifeq ($(BR2_PACKAGE_QT5WEBENGINE_PROPRIETARY_CODECS),y)
QT5WEBENGINE_CONF_OPTS += WEBENGINE_CONFIG+=use_proprietary_codecs
endif

ifeq ($(BR2_PACKAGE_QT5WEBENGINE_ALSA),y)
QT5WEBENGINE_DEPENDENCIES += alsa-lib
else
QT5WEBENGINE_CONF_OPTS += QT_CONFIG-=alsa
endif

# QtWebengine's build system uses python, but only supports python2. We work
# around this by forcing python2 early in the PATH, via a python->python2
# symlink.
QT5WEBENGINE_ENV = PATH=$(@D)/host-bin:$(BR_PATH)
define QT5WEBENGINE_PYTHON2_SYMLINK
	mkdir -p $(@D)/host-bin
	ln -sf $(HOST_DIR)/bin/python2 $(@D)/host-bin/python
endef
QT5WEBENGINE_PRE_CONFIGURE_HOOKS += QT5WEBENGINE_PYTHON2_SYMLINK

QT5WEBENGINE_ENV += NINJAFLAGS="-j$(PARALLEL_JOBS)"

define QT5WEBENGINE_CREATE_HOST_PKG_CONFIG
	sed s%@HOST_DIR@%$(HOST_DIR)%g $(QT5WEBENGINE_PKGDIR)/host-pkg-config.in > $(@D)/host-bin/host-pkg-config
	chmod +x $(@D)/host-bin/host-pkg-config
endef
QT5WEBENGINE_PRE_CONFIGURE_HOOKS += QT5WEBENGINE_CREATE_HOST_PKG_CONFIG
QT5WEBENGINE_ENV += GN_PKG_CONFIG_HOST=$(@D)/host-bin/host-pkg-config

QT5WEBENGINE_CONF_ENV = $(QT5WEBENGINE_ENV)
QT5WEBENGINE_MAKE_ENV = $(QT5WEBENGINE_ENV)

$(eval $(qmake-package))
