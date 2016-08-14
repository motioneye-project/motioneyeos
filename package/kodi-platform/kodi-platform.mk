################################################################################
#
# kodi-platform
#
################################################################################

KODI_PLATFORM_VERSION = 45d6ad1984fdb1dc855076ff18484dbec33939d1
KODI_PLATFORM_SITE = $(call github,xbmc,kodi-platform,$(KODI_PLATFORM_VERSION))
KODI_PLATFORM_LICENSE = GPLv2+
KODI_PLATFORM_LICENSE_FILES = src/util/XMLUtils.h
KODI_PLATFORM_INSTALL_STAGING = YES
KODI_PLATFORM_DEPENDENCIES = libplatform kodi

$(eval $(cmake-package))
