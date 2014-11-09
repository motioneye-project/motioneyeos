################################################################################
#
# grantlee
#
################################################################################
# qt4 support dropped after 0.5.1, so we use the older version for qt4
ifeq ($(BR2_PACKAGE_QT),y)
GRANTLEE_VERSION = 0.5.1
else ifeq ($(BR2_PACKAGE_QT5),y)
GRANTLEE_VERSION = 5.0.0
endif
GRANTLEE_SITE = http://downloads.grantlee.org
GRANTLEE_INSTALL_STAGING = YES
GRANTLEE_LICENSE = LGPLv2.1+
GRANTLEE_LICENSE_FILES = COPYING.LIB

ifeq ($(BR2_PACKAGE_QT),y)
GRANTLEE_DEPENDENCIES = qt
else ifeq ($(BR2_PACKAGE_QT5),y)
GRANTLEE_DEPENDENCIES += qt5base qt5script
endif

$(eval $(cmake-package))
