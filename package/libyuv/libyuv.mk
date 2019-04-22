################################################################################
#
# libyuv
#
################################################################################

LIBYUV_VERSION = 413a8d8041f1cc5a350a47c0d81cc721e64f9fd0
LIBYUV_SITE = https://chromium.googlesource.com/libyuv/libyuv
LIBYUV_SITE_METHOD = git
LIBYUV_LICENSE = BSD-3-Clause
LIBYUV_LICENSE_FILES = LICENSE
LIBYUV_INSTALL_STAGING = YES
LIBYUV_DEPENDENCIES = $(if $(BR2_PACKAGE_JPEG),jpeg)

$(eval $(cmake-package))
