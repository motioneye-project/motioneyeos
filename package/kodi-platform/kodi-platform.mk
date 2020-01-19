################################################################################
#
# kodi-platform
#
################################################################################

KODI_PLATFORM_VERSION = 915da086fa7b4ea72796052a04ed6de95501b95c
KODI_PLATFORM_SITE = $(call github,xbmc,kodi-platform,$(KODI_PLATFORM_VERSION))
KODI_PLATFORM_LICENSE = GPL-2.0+
KODI_PLATFORM_LICENSE_FILES = src/util/XMLUtils.h
KODI_PLATFORM_INSTALL_STAGING = YES
KODI_PLATFORM_DEPENDENCIES = libplatform kodi

$(eval $(cmake-package))
