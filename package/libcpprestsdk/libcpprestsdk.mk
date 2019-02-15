################################################################################
#
# libcpprestsdk
#
################################################################################

LIBCPPRESTSDK_VERSION = v2.10.10
LIBCPPRESTSDK_SITE = $(call github,Microsoft,cpprestsdk,$(LIBCPPRESTSDK_VERSION))
LIBCPPRESTSDK_LICENSE = MIT
LIBCPPRESTSDK_LICENSE_FILES = license.txt
LIBCPPRESTSDK_SUBDIR = Release
LIBCPPRESTSDK_DEPENDENCIES += host-pkgconf boost openssl zlib
LIBCPPRESTSDK_CONF_OPTS = -DWERROR=OFF -DCPPREST_EXCLUDE_WEBSOCKETS=ON -DBUILD_SAMPLES=OFF

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
LIBCPPRESTSDK_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -latomic"
endif

$(eval $(cmake-package))
