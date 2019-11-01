################################################################################
#
# grantlee
#
################################################################################

GRANTLEE_VERSION = 5.1.0
GRANTLEE_SITE = http://downloads.grantlee.org
GRANTLEE_INSTALL_STAGING = YES
GRANTLEE_LICENSE = LGPL-2.1+
GRANTLEE_LICENSE_FILES = COPYING.LIB
GRANTLEE_DEPENDENCIES = qt5base qt5script

# qt5 needs c++11 (since qt-5.7)
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
GRANTLEE_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -std=c++11"
endif

$(eval $(cmake-package))
