################################################################################
#
# kodi-platform
#
################################################################################

KODI_PLATFORM_VERSION = 33b6390b5d2abe5b674f9eb04bdee19228543054
KODI_PLATFORM_SITE = $(call github,xbmc,kodi-platform,$(KODI_PLATFORM_VERSION))
KODI_PLATFORM_LICENSE = GPLv2+
KODI_PLATFORM_LICENSE_FILES = src/util/XMLUtils.h
KODI_PLATFORM_INSTALL_STAGING = YES
KODI_PLATFORM_DEPENDENCIES = libplatform kodi

$(eval $(cmake-package))
