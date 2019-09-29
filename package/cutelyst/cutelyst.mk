################################################################################
#
# cutelyst
#
################################################################################

CUTELYST_VERSION = 2.7.0
CUTELYST_SITE = https://github.com/cutelyst/cutelyst/archive/v$(CUTELYST_VERSION)
CUTELYST_INSTALL_STAGING = YES
CUTELYST_SUPPORTS_IN_SOURCE_BUILD = NO
CUTELYST_LICENSE = LGPL-2.1+
CUTELYST_LICENSE_FILES = COPYING
CUTELYST_DEPENDENCIES = qt5base

CUTELYST_CONF_OPTS += \
	-DPLUGIN_CSRFPROTECTION=ON \
	-DPLUGIN_VIEW_GRANTLEE=OFF

# Qt 5.8 needs atomics, which on various architectures are in -latomic
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC)$(BR2_PACKAGE_QT5_VERSION_LATEST),yy)
CUTELYST_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -latomic"
endif

ifeq ($(BR2_PACKAGE_LIBPWQUALITY),y)
CUTELYST_CONF_OPTS += -DPLUGIN_VALIDATOR_PWQUALITY=ON
CUTELYST_DEPENDENCIES += libpwquality
else
CUTELYST_CONF_OPTS += -DPLUGIN_VALIDATOR_PWQUALITY=OFF
endif

ifeq ($(BR2_PACKAGE_JEMALLOC),y)
CUTELYST_CONF_OPTS += -DUSE_JEMALLOC=ON
CUTELYST_DEPENDENCIES += jemalloc
else
CUTELYST_CONF_OPTS += -DUSE_JEMALLOC=OFF
endif

$(eval $(cmake-package))
