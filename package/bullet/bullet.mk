################################################################################
#
# bullet
#
################################################################################

BULLET_VERSION = 2.89
BULLET_SITE = $(call github,bulletphysics,bullet3,$(BULLET_VERSION))
BULLET_INSTALL_STAGING = YES
BULLET_LICENSE = Zlib
BULLET_LICENSE_FILES = LICENSE.txt

# Disable demos apps and unit tests.
# Disable Bullet3 library.
BULLET_CONF_OPTS = -DBUILD_UNIT_TESTS=OFF \
	-DBUILD_BULLET2_DEMOS=OFF \
	-DBUILD_BULLET3=OFF

# extras needs dlfcn.h and NPTL (pthread_barrier_init)
ifeq ($(BR2_STATIC_LIBS):$(BR2_TOOLCHAIN_HAS_THREADS_NPTL),:y)
BULLET_CONF_OPTS += -DBUILD_EXTRAS=ON
else
BULLET_CONF_OPTS += -DBUILD_EXTRAS=OFF
endif

BULLET_CXXFLAGS = $(TARGET_CXXFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
BULLET_CXXFLAGS += -O0
endif

BULLET_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(BULLET_CXXFLAGS)"

$(eval $(cmake-package))
