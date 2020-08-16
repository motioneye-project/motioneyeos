################################################################################
#
# kf5-kcoreaddons
#
################################################################################

KF5_KCOREADDONS_VERSION = $(KF5_VERSION)
KF5_KCOREADDONS_SITE = $(KF5_SITE)
KF5_KCOREADDONS_SOURCE = kcoreaddons-$(KF5_KCOREADDONS_VERSION).tar.xz
KF5_KCOREADDONS_LICENSE = LGPL-2.1
KF5_KCOREADDONS_LICENSE_FILES = COPYING.LIB

KF5_KCOREADDONS_DEPENDENCIES = kf5-extra-cmake-modules qt5tools
KF5_KCOREADDONS_INSTALL_STAGING = YES

KF5_KCOREADDONS_CXXFLAGS = $(TARGET_CXXFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
KF5_KCOREADDONS_CXXFLAGS += -latomic
endif

KF5_KCOREADDONS_CONF_OPTS = -DCMAKE_CXX_FLAGS="$(KF5_KCOREADDONS_CXXFLAGS)"

ifeq ($(BR2_microblaze),y)
# Microblaze ld emits warnings, make warnings not to be treated as errors
KF5_KCOREADDONS_CONF_OPTS += -DCMAKE_SHARED_LINKER_FLAGS="-Wl,--no-fatal-warnings"
endif

$(eval $(cmake-package))
