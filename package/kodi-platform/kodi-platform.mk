################################################################################
#
# kodi-platform
#
################################################################################

KODI_PLATFORM_VERSION = 36fb49371dbce49bf470a5bb1fc51b74b4a3612d
KODI_PLATFORM_SITE = $(call github,xbmc,kodi-platform,$(KODI_PLATFORM_VERSION))
KODI_PLATFORM_LICENSE = GPL-2.0+
KODI_PLATFORM_LICENSE_FILES = src/util/XMLUtils.h
KODI_PLATFORM_INSTALL_STAGING = YES
KODI_PLATFORM_DEPENDENCIES = libplatform kodi

$(eval $(cmake-package))
