################################################################################
#
# qt5
#
################################################################################

ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5_VERSION_MAJOR = 5.12
QT5_VERSION = $(QT5_VERSION_MAJOR).4
QT5_SOURCE_TARBALL_PREFIX = everywhere-src
else
QT5_VERSION_MAJOR = 5.6
QT5_VERSION = $(QT5_VERSION_MAJOR).3
QT5_SOURCE_TARBALL_PREFIX = opensource-src
endif
QT5_SITE = https://download.qt.io/archive/qt/$(QT5_VERSION_MAJOR)/$(QT5_VERSION)/submodules

include $(sort $(wildcard package/qt5/*/*.mk))

# Variable for other Qt applications to use
QT5_QMAKE = $(HOST_DIR)/bin/qmake -spec devices/linux-buildroot-g++
