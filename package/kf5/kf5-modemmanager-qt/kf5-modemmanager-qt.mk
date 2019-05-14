################################################################################
#
# kf5-modemmanager-qt
#
################################################################################

KF5_MODEMMANAGER_QT_VERSION = $(KF5_VERSION)
KF5_MODEMMANAGER_QT_SITE = $(KF5_SITE)
KF5_MODEMMANAGER_QT_SOURCE = modemmanager-qt-$(KF5_MODEMMANAGER_QT_VERSION).tar.xz
KF5_MODEMMANAGER_QT_LICENSE = LGPL-2.1+
KF5_MODEMMANAGER_QT_LICENSE_FILE = COPYING.LIB

KF5_MODEMMANAGER_QT_DEPENDENCIES = kf5-extra-cmake-modules modem-manager qt5base
KF5_MODEMMANAGER_QT_INSTALL_STAGING = YES

# Uses __atomic_fetch_add_4
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
KF5_MODEMMANAGER_QT_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -latomic"
endif

$(eval $(cmake-package))
