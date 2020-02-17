################################################################################
#
# qt5webkit
#
################################################################################

QT5WEBKIT_VERSION = 5.9.1
QT5WEBKIT_SITE = https://download.qt.io/official_releases/qt/5.9/5.9.1/submodules
QT5WEBKIT_SOURCE = qtwebkit-opensource-src-$(QT5WEBKIT_VERSION).tar.xz
QT5WEBKIT_DEPENDENCIES = \
	host-bison host-flex host-gperf host-python host-ruby \
	leveldb sqlite
QT5WEBKIT_INSTALL_STAGING = YES

QT5WEBKIT_LICENSE_FILES = Source/WebCore/LICENSE-LGPL-2 Source/WebCore/LICENSE-LGPL-2.1

QT5WEBKIT_LICENSE = LGPL-2.1+, BSD-3-Clause, BSD-2-Clause
# Source files contain references to LGPL_EXCEPTION.txt but it is not included
# in the archive.
QT5WEBKIT_LICENSE_FILES += LICENSE.LGPLv21

ifeq ($(BR2_PACKAGE_QT5BASE_XCB),y)
QT5WEBKIT_DEPENDENCIES += xlib_libXext xlib_libXrender
endif

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5WEBKIT_DEPENDENCIES += qt5declarative
endif

# QtWebkit's build system uses python, but only supports python2. We work
# around this by forcing python2 early in the PATH, via a python->python2
# symlink.
QT5WEBKIT_CONF_ENV = PATH=$(@D)/host-bin:$(BR_PATH)
QT5WEBKIT_MAKE_ENV = PATH=$(@D)/host-bin:$(BR_PATH)
define QT5WEBKIT_PYTHON2_SYMLINK
	mkdir -p $(@D)/host-bin
	ln -sf $(HOST_DIR)/bin/python2 $(@D)/host-bin/python
endef
QT5WEBKIT_PRE_CONFIGURE_HOOKS += QT5WEBKIT_PYTHON2_SYMLINK

QT5WEBKIT_CONF_OPTS = WEBKIT_CONFIG+=use_system_leveldb

define QT5WEBKIT_INSTALL_TARGET_EXTRAS
	cp -dpf $(@D)/bin/* $(TARGET_DIR)/usr/bin/
endef

QT5WEBKIT_POST_INSTALL_TARGET_HOOKS += QT5WEBKIT_INSTALL_TARGET_EXTRAS

$(eval $(qmake-package))
