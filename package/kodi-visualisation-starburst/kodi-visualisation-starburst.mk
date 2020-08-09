################################################################################
#
# kodi-visualisation-starburst
#
################################################################################

KODI_VISUALISATION_STARBURST_VERSION = 2.0.2-Leia
KODI_VISUALISATION_STARBURST_SITE = $(call github,xbmc,visualization.starburst,$(KODI_VISUALISATION_STARBURST_VERSION))
KODI_VISUALISATION_STARBURST_LICENSE = GPL-2.0+
KODI_VISUALISATION_STARBURST_LICENSE_FILES = debian/copyright
KODI_VISUALISATION_STARBURST_DEPENDENCIES = glm kodi

$(eval $(cmake-package))
