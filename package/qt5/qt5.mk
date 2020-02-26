################################################################################
#
# qt5
#
################################################################################

QT5_VERSION_MAJOR = 5.12
QT5_VERSION = $(QT5_VERSION_MAJOR).7
QT5_SOURCE_TARBALL_PREFIX = everywhere-src
QT5_SITE = https://download.qt.io/archive/qt/$(QT5_VERSION_MAJOR)/$(QT5_VERSION)/submodules

include $(sort $(wildcard package/qt5/*/*.mk))

# Variable for other Qt applications to use
QT5_QMAKE = $(HOST_DIR)/bin/qmake -spec devices/linux-buildroot-g++
