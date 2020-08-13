################################################################################
#
# libimxvpuapi
#
################################################################################

LIBIMXVPUAPI_VERSION = 0.10.3
LIBIMXVPUAPI_SITE = $(call github,Freescale,libimxvpuapi,$(LIBIMXVPUAPI_VERSION))
LIBIMXVPUAPI_LICENSE = LGPL-2.1+
LIBIMXVPUAPI_LICENSE_FILES = LICENSE
LIBIMXVPUAPI_DEPENDENCIES = host-pkgconf host-python imx-vpu
LIBIMXVPUAPI_INSTALL_STAGING = YES
LIBIMXVPUAPI_NEEDS_EXTERNAL_WAF = YES

$(eval $(waf-package))
