################################################################################
#
# kf5-networkmanager-qt
#
################################################################################

KF5_NETWORKMANAGER_QT_VERSION = $(KF5_VERSION)
KF5_NETWORKMANAGER_QT_SITE = $(KF5_SITE)
KF5_NETWORKMANAGER_QT_SOURCE = networkmanager-qt-$(KF5_NETWORKMANAGER_QT_VERSION).tar.xz
KF5_NETWORKMANAGER_QT_LICENSE = LGPL-2.1+
KF5_NETWORKMANAGER_QT_LICENSE_FILES = COPYING.LIB

KF5_NETWORKMANAGER_QT_DEPENDENCIES = kf5-extra-cmake-modules network-manager qt5base
KF5_NETWORKMANAGER_QT_INSTALL_STAGING = YES

$(eval $(cmake-package))
