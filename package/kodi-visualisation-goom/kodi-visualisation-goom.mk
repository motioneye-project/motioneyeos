################################################################################
#
# kodi-visualisation-goom
#
################################################################################

KODI_VISUALISATION_GOOM_VERSION = v1.1.0
KODI_VISUALISATION_GOOM_SITE = $(call github,notspiff,visualization.goom,$(KODI_VISUALISATION_GOOM_VERSION))
KODI_VISUALISATION_GOOM_LICENSE = GPL-2.0+
KODI_VISUALISATION_GOOM_LICENSE_FILES = src/Main.cpp

KODI_VISUALISATION_GOOM_DEPENDENCIES = kodi

$(eval $(cmake-package))
