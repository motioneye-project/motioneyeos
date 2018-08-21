################################################################################
#
# libcpprestsdk
#
################################################################################

LIBCPPRESTSDK_VERSION = v2.10.5
LIBCPPRESTSDK_SITE = $(call github,Microsoft,cpprestsdk,$(LIBCPPRESTSDK_VERSION))
LIBCPPRESTSDK_LICENSE = MIT
LIBCPPRESTSDK_LICENSE_FILES = license.txt
LIBCPPRESTSDK_SUBDIR = Release
LIBCPPRESTSDK_DEPENDENCIES += host-pkgconf boost openssl zlib
LIBCPPRESTSDK_CONF_OPTS = -DWERROR=OFF

$(eval $(cmake-package))
