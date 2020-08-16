################################################################################
#
# kf5-extra-cmake-modules
#
################################################################################

KF5_EXTRA_CMAKE_MODULES_VERSION = $(KF5_VERSION)
KF5_EXTRA_CMAKE_MODULES_SITE = $(KF5_SITE)
KF5_EXTRA_CMAKE_MODULES_SOURCE = extra-cmake-modules-$(KF5_EXTRA_CMAKE_MODULES_VERSION).tar.xz
KF5_EXTRA_CMAKE_MODULES_LICENSE = BSD-3-Clause
KF5_EXTRA_CMAKE_MODULES_LICENSE_FILES = COPYING-CMAKE-SCRIPTS

KF5_EXTRA_CMAKE_MODULES_DEPENDENCIES = host-pkgconf
KF5_EXTRA_CMAKE_MODULES_INSTALL_STAGING = YES
KF5_EXTRA_CMAKE_MODULES_INSTALL_TARGET = NO

$(eval $(cmake-package))
