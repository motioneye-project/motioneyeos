################################################################################
#
# proj
#
################################################################################

PROJ_VERSION = 6.3.0
PROJ_SITE = http://download.osgeo.org/proj
PROJ_LICENSE = MIT
PROJ_LICENSE_FILES = COPYING
PROJ_INSTALL_STAGING = YES
PROJ_DEPENDENCIES = host-pkgconf host-sqlite sqlite

PROJ_CFLAGS = $(TARGET_CFLAGS)
PROJ_CXXFLAGS = $(TARGET_CXXFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_68485),y)
PROJ_CFLAGS += -O0
PROJ_CXXFLAGS += -O0
endif

PROJ_CONF_ENV = \
	CFLAGS="$(PROJ_CFLAGS)" \
	CXXFLAGS="$(PROJ_CXXFLAGS)"

$(eval $(autotools-package))
