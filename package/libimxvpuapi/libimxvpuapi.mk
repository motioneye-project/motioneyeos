################################################################################
#
# libimxvpuapi
#
################################################################################

LIBIMXVPUAPI_VERSION = 0.10.3
LIBIMXVPUAPI_SITE = $(call github,Freescale,libimxvpuapi,$(LIBIMXVPUAPI_VERSION))
LIBIMXVPUAPI_LICENSE = LGPLv2.1+
LIBIMXVPUAPI_LICENSE_FILES = LICENSE
LIBIMXVPUAPI_DEPENDENCIES = host-pkgconf host-python imx-vpu
LIBIMXVPUAPI_INSTALL_STAGING = YES

$(eval $(waf-package))
